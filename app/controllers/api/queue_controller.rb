class Api::QueueController < Api::BaseController

  def now_playing
    song = PlayQueue.now_playing
    deliver_json(200, {:now_playing => song_response(song, current_user)})
  end

  def list
    deliver_json(200, songs_response(PlayQueue.songs, current_user))
  end

  def add
    case params[:type]
    when /song/
      artist = Artist.new(:name => params[:artist_name])
      song = artist.songs.find{|song| song.title == params[:song_name]}
      PlayQueue.add(song,current_user)
    when /album/
      artist = Artist.new(:name => params[:artist_name])
      album  = Album.new(:artist => artist, :name => params[:album_name])
      album.songs.each{|song| PlayQueue.add(song, current_user)}
    end

    deliver_json(200, songs_response(PlayQueue.songs, current_user))
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


end
