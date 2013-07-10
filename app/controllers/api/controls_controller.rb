class Api::ControlsController < Api::BaseController

  def now_playing
    song = Song.now_playing
    deliver_json(200, {:now_playing => song.try(:to_hash)})
  end

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
