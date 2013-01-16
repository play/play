require 'rubygems'
require 'bundler'

Bundler.setup(:default)
Bundler.require(:default)

require_relative 'helpers/authentication_helper'

require_relative 'models/album'
require_relative 'models/artist'
require_relative 'models/client'
require_relative 'models/helpers'
require_relative 'models/like'
require_relative 'models/queue'
require_relative 'models/song'
require_relative 'models/song_play'
require_relative 'models/user'

require_relative 'views/layout'

include Play::Helpers

module Play
  def self.client
    Client.new
  end

  # mpd only really knows about the relative path to songs:
  # Justice/Cross/Stress.mp3, for example. We need to know the path before
  # that for a few things (reading in the MP3 tag data, for one). This method
  # reads the path from your config/mpd.conf and loads up the value you have
  # for `music_directory`.
  #
  # Returns a String.
  def self.music_path
    config = File.read('config/mpd.conf')
    config.match(/music_directory\s+"(.+)"/)
    $1
  end

  # Directory where cached album art images will be stored.
  def self.album_art_cache_path
    'public/art'
  end

  # The config file of Play. Contains things like keys, database config, and
  # who shot JFK.
  #
  # Returns a Hash.
  def self.config
    YAML::load(File.open('config/play.yml'))
  end

  # The uri prefix we have set for play. This allows us to run play in a sub-directory
  # on our webserver if we want.
  def self.uri_prefix
    self.config['uri_prefix']
  end
end

require_relative 'app'
