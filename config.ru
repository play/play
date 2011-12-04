require File.expand_path(File.dirname(__FILE__) + '/lib/play')

require 'omniauth/oauth'
oauth = Play.config

use Rack::Session::Cookie
use OmniAuth::Strategies::GitHub, oauth['gh_key'], oauth['gh_secret']

run Play::App
