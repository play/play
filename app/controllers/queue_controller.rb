class QueueController < ApplicationController
  def index
    @songs = PlayQueue.songs
  end
end
