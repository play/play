class Api::ControlsController < Api::BaseController

  def play
    channel.mpd.play
    deliver_json(200, {:message => 'ok'})
  end

  def pause
    channel.mpd.pause = true
    deliver_json(200, {:message => 'ok'})
  end

  def next
    channel.mpd.next
    deliver_json(200, {:message => 'ok'})
  end

end
