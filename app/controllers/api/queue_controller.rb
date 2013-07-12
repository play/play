class Api::QueueController < Api::BaseController

  def now_playing
    song = PlayQueue.now_playing
    deliver_json(200, {:now_playing => song.try(:to_hash)})
  end

  def list
  end

  def add
  end

  def remove
  end

  def clear
  end


end
