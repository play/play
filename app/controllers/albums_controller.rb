class AlbumsController < ApplicationController
  def show
    @artist = Artist.new(params[:artist_name])
    @album  = Album.new(@artist.name, CGI.unescape(params[:name]))
    @songs  = @album.songs
  end
end
