class QueueController < ApplicationController
  def index
    @songs = Play.default_channel.queue
  end

  def create
    case params[:type]
    when /song/
      song = Song.from_path(params[:id])
      Play.default_channel.add(song,current_user)
    when /album/
      artist = Artist.new(:name => params[:artist])
      album  = Album.new(:artist => artist, :name => params[:name])
      album.songs.each{|song| Play.default_channel.add(song, current_user)}
    end

    render :text => 'added!'
  end

  def destroy
    song = Song.from_path(params[:id])
    Play.default_channel.remove(song,current_user)
    render :text => 'deleted!'
  end
end
