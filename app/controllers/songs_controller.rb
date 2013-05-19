class SongsController < ApplicationController
  def show
    @artist = Artist.new(params[:artist_name])
    @song   = @artist.songs.find{|song| song.title == CGI.unescape(params[:title])}
  end
end
