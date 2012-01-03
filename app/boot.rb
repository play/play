$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler/setup"
require 'logger'

require 'coffee-script'
require 'sinatra/base'
require 'mustache/sinatra'
require 'yajl'
require 'appscript' if RUBY_PLATFORM.downcase.include?("darwin")

require 'models/artist'
require 'models/album'
require 'models/player'
require 'models/queue'
require 'models/song'

require 'app'
require 'views/layout'

module Play
end
