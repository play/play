class Api::AlbumsController < Api::BaseController

  def index
    artist = Artist.new(:name => params[:artist_name])

    deliver_json(200, albums_response(artist.albums, current_user))
  end

  def show
    artist = Artist.new(:name => params[:artist_name])
    album = Album.new(:artist => artist, :name => params[:album_name])

    deliver_json(200, album_response(album, current_user))
  end

  def download
    artist = Artist.new(:name => params[:artist_name])
    album = Album.new(:artist => artist, :name => params[:album_name])
    path   = File.join(Play.music_path,params[:artist_name],params[:album_name])
    zipped = album.zipped(path)

    send_file(zipped, :disposition => 'attachment')
  end

end
