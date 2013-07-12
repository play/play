class Api::ControlsController < Api::BaseController

  def play
    Play.mpd.play
    deliver_json(200, {:message => 'ok'})
  end

  def pause
    Play.mpd.pause
    deliver_json(200, {:message => 'ok'})
  end

  def next
    Play.mpd.next
    deliver_json(200, {:message => 'ok'})
  end

end
