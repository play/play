require 'rack/websocket'
class Realtime < Rack::WebSocket::Application
  def initialize(options = {})
    super
  end

  def on_close(env)
    @timer.cancel
  end

  def on_message(env, msg)
  end

  def on_error(env, error)
  end

  def on_open(env)
    last = nil

    @timer = EM::PeriodicTimer.new(1) do
      if last != last=current
        send_data last
      end
      sleep 0.5
    end
  end

private

  # The current JSON representation of Play that we send back.
  #
  # Returns a String, JSON-encoded.
  def current
    hash = {
      :now_playing => Play::Player.now_playing.to_json
    }
    Yajl.dump hash
  end
end