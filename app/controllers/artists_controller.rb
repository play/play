class ArtistsController < ApplicationController
  def show
    @artist = Artist.new(params[:artist_name])
    @albums = @artist.albums
  end

  def songs
    @artist = Artist.new(params[:artist_name])
    @songs = @artist.songs.sort_by { |song| song.title }
    render :show
  end
end
