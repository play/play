class Api::ChannelsController < Api::BaseController

  before_filter :find_channel

  def now_playing
    song = @channel.now_playing
    deliver_json(200, {:now_playing => song_response(song, current_user)})
  end

  def like_now_playing
    song = @channel.now_playing
    current_user.like(song.path)

    deliver_json(200, {:now_playing => song_response(song, current_user)})
  end

  def play
    @channel.mpd.play
    deliver_json(200, {:message => 'ok'})
  end

  def pause
    @channel.mpd.pause = true
    deliver_json(200, {:message => 'ok'})
  end

  def next
    @channel.mpd.next
    deliver_json(200, {:message => 'ok'})
  end

  def list
    deliver_json(200, songs_response(@channel.queue, current_user))
  end

  def add
    songs = []

    case params[:type]
    when /song/
      artist = Artist.new(:name => params[:artist_name])
      song = artist.songs.find{|song| song.title.downcase == params[:song_name].downcase}
      return deliver_json(404, "Can't find song") if !song
      @channel.add(song,current_user)
      songs = [song]
    when /artist/
      artist = Artist.new(:name => params[:artist_name])
      songs = artist.songs.sample(3)
      songs.each{|song| @channel.add(song, current_user)}
    when /album/
      artist_name = @channel.mpd.search(:artist, params[:artist_name], :case_sensitive => false).first.try(:artist)
      artist = Artist.new(:name => artist_name)
      album  = artist.albums.select { |album| album.name.downcase == params[:album_name].downcase }.first
      album.songs.each{|song| @channel.add(song, current_user)}
      songs = album.songs
    end

    deliver_json(200, songs_response(songs, current_user))
  end

  def remove
    artist = Artist.new(:name => params[:artist_name])
    song = artist.songs.find{|song| song.title == params[:song_name]}
    @channel.remove(song,current_user)

    deliver_json(200, songs_response(@channel.queue, current_user))
  end

  def clear
    @channel.mpd.clear

    deliver_json(200, songs_response(@channel.queue, current_user))
  end

  def stars
    songs = current_user.likes.limit(3).order('rand()').collect(&:song)
    songs.each do |song|
      @channel.add(song,current_user)
    end

    deliver_json(200, songs_response(songs, current_user))
  end


  private

  def find_channel
    @channel = Channel.find(params[:channel_id]) if params[:channel_id]
  end

end
