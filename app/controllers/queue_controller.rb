class QueueController < ApplicationController
  def index
    @songs = PlayQueue.songs
  end

  def create
    song = Song.new(params[:path])
    Queue.add(song,current_user)
    'added!'
  end

  def destroy
    song = Song.new(params[:path])
    Queue.remove(song,current_user)
    'deleted!'
  end
end
