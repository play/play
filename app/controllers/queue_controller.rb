class QueueController < ApplicationController
  def index
    @songs = PlayQueue.songs
  end

  def create
    song = Song.new(:path => params[:id])
    PlayQueue.add(song,current_user)
    render :text => 'added!'
  end

  def destroy
    song = Song.new(:path => params[:id])
    PlayQueue.remove(song,current_user)
    render :text => 'deleted!'
  end
end
