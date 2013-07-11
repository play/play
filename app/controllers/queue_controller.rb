class QueueController < ApplicationController
  def index
    @songs = PlayQueue.songs
  end

  def create

    case params[:type]
    when /song/
      song = Song.new(:path => params[:id])
      PlayQueue.add(song,current_user)
    when /album/
      artist = Artist.new(:name => params[:artist])
      album  = Album.new(:artist => artist, :name => params[:name])
      album.songs.each{|song| PlayQueue.add(song, current_user)}
    end

    render :text => 'added!'
  end

  def destroy
    song = Song.new(:path => params[:id])
    PlayQueue.remove(song,current_user)
    render :text => 'deleted!'
  end
end
