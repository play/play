$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler/setup"
require 'logger'

require 'redis'
require 'coffee-script'
require 'sinatra/base'
require 'mustache/sinatra'
require 'sinatra_auth_github'
require 'yajl'
require 'appscript' if RUBY_PLATFORM.downcase.include?("darwin")

require 'play'

require 'models/artist'
require 'models/album'
require 'models/history'
require 'models/player'
require 'models/queue'
require 'models/song'

require 'app'
require 'views/layout'

REDIS_URL = 'redis://127.0.0.1'
$redis = Redis.connect(:url => REDIS_URL, :thread_safe => true)