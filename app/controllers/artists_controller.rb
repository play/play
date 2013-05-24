class ArtistsController < ApplicationController
  def show
    @artist = Artist.new(CGI.unescape(params[:name]))
    @albums = @artist.albums
  end

  def songs
    @artist = Artist.new(CGI.unescape(params[:name]))
    @songs = @artist.songs.sort_by { |song| song.title }
    render :show
  end
end
