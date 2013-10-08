require "play/api/error_delivery"
require "play/api/json_delivery"
require "play/api/api_response"
require "play/speaker"
require "play/commands"
require "play/commands/channels"
require "play/commands/controls"
require "play/commands/help"
require "play/commands/information"
require "play/commands/queueing"
require "play/commands/speakers"

module Play

  # Convenience method giving access to the "library" to make the API feel
  # a little better.
  #
  # Returns MPD client.
  def self.library
    @mpd ||= default_channel.mpd
  end

  def self.default_channel
    @default_channel ||= Channel.first
  end

  # mpd only really knows about the relative path to songs:
  # Justice/Cross/Stress.mp3, for example. We need to know the path before
  # that for a few things (reading in the MP3 tag data, for one). This method
  # reads the path from your config/mpd.conf and loads up the value you have
  # for `music_directory`.
  #
  # Returns a String.
  def self.music_path
    Play.config['mpd']['music_path']
  end

  # Directory where MPD config things will be stored, library database, etc.
  def self.global_mpd_config_path
    File.expand_path('~/.mpd')
  end

  # Directory where cached album art images will be stored.
  def self.album_art_cache_path
    'public/images/art'
  end

  # Returns boolean for if MPD should support system audio.
  def self.system_audio
    Play.config['mpd']['system_audio']
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

  # Starts a music server for each channel
  def self.start_servers
    Channel.all.each do |channel|
      channel.start
    end
  end

  # Stops all music servers
  def self.stop_servers
    Channel.all.each do |channel|
      channel.stop
    end
  end

  # Clears the queues of all Channels.
  #
  # Returns nothing.
  def self.clear_queues
    Channel.all.each do |channel|
      channel.clear
    end
  end

  #
  def self.queued?(song)
    Channel.all.collect(&:queue).flatten.include?(song)
  end

  # def self.search(type, query, options={})
  #   mpd.search(type, query, options)
  # end


  # Returns the cached request host.
  #
  # Returns String.
  def self.request_host
    @request_host
  end

  # Sets the host that the request is happening on.
  #
  # Returns String.
  def self.request_host=(host)
    @request_host = host
  end


end
