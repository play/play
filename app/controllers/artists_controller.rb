class ArtistsController < ApplicationController
  def show
    @artist = Artist.new(:name => params[:artist_name])
    @albums = @artist.albums
  end

  def songs
    @artist = Artist.new(:name => params[:artist_name])
    @songs = @artist.songs.sort_by { |song| song.title }
    render :show
  end
end
