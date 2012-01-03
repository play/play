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
    send_data Play::Player.now_playing.to_json
  end
end