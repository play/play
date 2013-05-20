class QueueController < ApplicationController
  def index
    @songs = PlayQueue.songs
  end

  def create
    song = Song.new(params[:path])
    PlayQueue.add(song,current_user)
    render :text => 'added!'
  end

  def destroy
    song = Song.new(params[:id])
    PlayQueue.remove(song,current_user)
    render :text => 'deleted!'
  end
end
