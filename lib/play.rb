$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler/setup"
require 'logger'

require 'coffee-script'
require 'sinatra/base'
require 'mustache/sinatra'
require 'digest'
require 'yajl'
require 'appscript' if RUBY_PLATFORM.downcase.include?("darwin")

require './app/models/artist'
require './app/models/album'
require './app/models/player'
require './app/models/queue'
require './app/models/song'

require 'play/core_ext/hash'

require 'play/app'
require 'play/views/layout'

module Play
  # The path to your music library. All of the music underneath this directory
  # will be added to the internal library.
  #
  #   path - a String absolute path to your music
  #
  # Returns nothing.
  def self.path=(path)
    @path = path
  end

  # The path of the music library on-disk.
  #
  # Returns a String absolute path on the local file system.
  def self.path
    config['path']
  end

  # The path to play.yml.
  #
  # Returns the String path to the configuration file.
  def self.config_path
    "config/play.yml"
  end

  # The configuration object for Play.
  #
  # Returns the Hash containing the configuration for Play. This includes:
  #
  #   path - the String path to where your music is located
  #   gh_key - the Client ID from your GitHub app's OAuth settings
  #   gh_secret - the Client Secret from your GitHub app's OAuth settings
  #   office_url - the URL to an endpoint where we can see who's in your office
  def self.config
    YAML::load(File.open(config_path))
  end

end
