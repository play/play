class Api::QueueController < Api::BaseController

  def now_playing
    song = PlayQueue.now_playing
    deliver_json(200, {:now_playing => song.try(:to_hash)})
  end

  def list
    deliver_json(200, {:songs => PlayQueue.songs.collect(&:to_hash)})
  end

  def add
  end

  def remove
  end

  def clear
  end


end
