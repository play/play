class Api::QueueController < Api::BaseController

  SOUNDCLOUD_URL = /^https?:\/\/(www\.)?soundcloud\.com\/.+?\/.+/

  def now_playing
    song = PlayQueue.now_playing
    deliver_json(200, {:now_playing => song_response(song, current_user)})
  end

  def like_now_playing
    song = PlayQueue.now_playing
    current_user.like(song.path)

    deliver_json(200, {:now_playing => song_response(song, current_user)})
  end

  def list
    deliver_json(200, songs_response(PlayQueue.songs, current_user))
  end

  def add
    songs = []

    case params[:type]
    when /song/
      artist = Artist.new(:name => params[:artist_name])
      song = artist.songs.find{|song| song.title.downcase == params[:song_name].downcase}
      return deliver_json(404, "Can't find song") if !song
      PlayQueue.add(song,current_user)
      songs = [song]
    when /artist/
      artist = Artist.new(:name => params[:artist_name])
      songs = artist.songs.sample(3)
      songs.each{|song| PlayQueue.add(song, current_user)}
    when /album/
      artist_name = Play.mpd.search(:artist, params[:artist_name], :case_sensitive => false).first.try(:artist)
      artist = Artist.new(:name => artist_name)
      album  = artist.albums.select { |album| album.name.downcase == params[:album_name].downcase }.first
      album.songs.each{|song| PlayQueue.add(song, current_user)}
      songs = album.songs
    when /soundcloud/
      return deliver_json(404, "No proper SoundCloud URL given") if params[:url].nil? or params[:url] !~ SOUNDCLOUD_URL
      track = soundcloud_client.get('/resolve', :url => params[:url])
      return deliver_json(404, "SoundCloud URL is not streamable!") unless track["streamable"]
      song = Song.new(:path => params[:url])
      options = { :track_id => track['id'] }
      PlayQueue.add(song, current_user, options)
      songs = [song]
    end

    deliver_json(200, songs_response(songs, current_user))
  end

  def remove
    artist = Artist.new(:name => params[:artist_name])
    song = artist.songs.find{|song| song.title == params[:song_name]}
    PlayQueue.remove(song,current_user)

    deliver_json(200, songs_response(PlayQueue.songs, current_user))
  end

  def clear
    Play.mpd.clear

    deliver_json(200, songs_response(PlayQueue.songs, current_user))
  end

  def stars
    songs = current_user.likes.limit(3).order('rand()').collect(&:song)
    songs.each do |song|
      PlayQueue.add(song,current_user)
    end

    deliver_json(200, songs_response(songs, current_user))
  end


end
