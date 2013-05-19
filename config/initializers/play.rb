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
    'public/images/art'
  end

  # The config file of Play. Contains things like keys, database config, and
  # who shot JFK.
  #
  # Returns a Hash.
  def self.config
    YAML::load(File.open('config/play.yml'))
  end
end

# Set up mpd to natively consume songs
Play.client.native :repeat,  [true]
Play.client.native :consume, [true]

# Scan for new songs just in case
Play.client.native :update