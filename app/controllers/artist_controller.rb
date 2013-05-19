class ArtistController < ApplicationController
  def index
    @artist = Artist.new(params[:name])
    @albums = @artist.albums
  end
end
