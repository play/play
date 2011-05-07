$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler/setup"

require 'active_record'
require 'audioinfo'
require 'sinatra/base'
require 'mustache/sinatra'
require 'digest'
require 'yajl'

require 'play/core_ext/hash'

require 'play/app'
require 'play/artist'
require 'play/album'
require 'play/client'
require 'play/history'
require 'play/library'
require 'play/office'
require 'play/song'
require 'play/views/layout'
require 'play/user'
require 'play/vote'

module Play
  
  VERSION = '0.0.2'

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

  # The song that's currently playing.
  #
  # Returns the Song object from the database that's currently playing.
  def self.now_playing
    Song.where(:now_playing => true).first
  end

  # The path to play.yml.
  #
  # Returns the String path to the configuration file.
  def self.config_path
    "#{ENV['HOME']}/.play.yml"
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
