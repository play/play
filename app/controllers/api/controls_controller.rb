class Api::ControlsController < Api::BaseController

  def now_playing
    song = Song.now_playing
    deliver_json(200, {:now_playing => song.try(:to_hash)})
  end

  def play
    Play.client.play
    deliver_json(200, {:message => 'ok'})
  end

  def pause
    Play.client.pause
    deliver_json(200, {:message => 'ok'})
  end

  def next
    Play.client.next
    JSON::dump(200, {:message => 'ok'})
  end

end
