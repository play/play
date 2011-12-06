require File.expand_path(File.dirname(__FILE__) + '/lib/play')

require 'omniauth/oauth'
oauth = Play.config

use Rack::Session::Cookie
use OmniAuth::Strategies::GitHub, oauth['gh_key'], oauth['gh_secret']

require 'sass/plugin/rack'
Sass::Plugin.options[:template_location] = 'public/scss'
Sass::Plugin.options[:stylesheet_location] = 'public/stylesheets'
use Sass::Plugin::Rack

run Play::App
