class ArtistsController < ApplicationController
  def show
    @artist = Artist.new(params[:name])
    @albums = @artist.albums
  end

  def songs
    @artist = Artist.new(params[:name])
    @songs = @artist.songs
    render :show
  end
end
