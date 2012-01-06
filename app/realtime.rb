require 'rack/websocket'
class Realtime < Rack::WebSocket::Application
  def initialize(options = {})
    super
  end

  def on_close(env)
    puts "Client disconnected"
  end

  def on_message(env, msg)
    puts "Received message: " + msg
  end

  def on_error(env, error)
    puts "Error occured: " + error.message
  end

  def on_open(env)
    last = nil

    EM.add_periodic_timer(1) do
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