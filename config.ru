require File.expand_path(File.dirname(__FILE__) + '/lib/play')
require 'sprockets'

require 'omniauth/oauth'
oauth = Play.config

use Rack::Session::Cookie
use OmniAuth::Strategies::GitHub, oauth['gh_key'], oauth['gh_secret']

stylesheets = Sprockets::Environment.new
stylesheets.append_path 'app/frontend/styles'

javascripts = Sprockets::Environment.new
javascripts.append_path 'app/frontend/scripts'

map("/css") { run stylesheets }
map("/js")  { run javascripts }

map('/')    { run Play::App }

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
map('/realtime') { run Realtime.new }