require "play/api/error_delivery"
require "play/api/json_delivery"
require "play/api/api_response"
require "play/speaker"

module Play

  # Our connection to MPD.
  #
  # Returns an instance of MPD.
  def self.mpd
    return nil if !defined?(Channel)
    @mpd ||= Channel.first && Channel.first.mpd
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
    config.scan(/^(?<!#)\s*music_directory\s+"([^"]*)"$/).last.first
  end

  # Directory where cached album art images will be stored.
  def self.album_art_cache_path
    'public/images/art'
  end

  # The config file of Play. Contains things like keys, database config, and
  # who shot JFK.
  #
  # Returns a Hash.
  def self.config
    @config ||= YAML::load(File.open('config/play.yml'))
  end

  # Local instances of Play Speakers found on the network
  #
  # Returns an array of Speaker objects.
  def self.speakers
    @speakers ||= []
  end

end
