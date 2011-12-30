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