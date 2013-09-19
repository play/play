class Channel < ActiveRecord::Base
  attr_accessible :mpd_port, :httpd_port, :color, :name

  has_many :users

  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  validates_uniqueness_of :httpd_port, :on => :create, :message => "must be unique"
  validates_uniqueness_of :mpd_port, :on => :create, :message => "must be unique"

  before_save :set_ports
  after_save :restart
  before_destroy :stop


  # Starts the mpd server for this channel.
  #
  # This first writes out a fresh mpd.conf for the mpd process and then starts
  # it up, and then connects to the MPD.
  #
  # Returns an MPD client.
  def start
    write_config
    `mpd '#{config_path}' > /dev/null 2>&1`

    connection = connect

    if !Rails.env.test? && mpd

      # Set up mpd to natively consume songs
      mpd.repeat  = true
      mpd.consume = true

      # Scan for new songs just in case
      mpd.update

      # Play the tunes
      mpd.play
    end

    connection
  end

  # Stops the mpd server for this channel.
  #
  # Returns nothing.
  def stop
    `mpd '#{config_path}' --kill > /dev/null 2>&1`
  end

  # Restarts the mpd server for this channel.
  #
  # Returns nothing.
  def restart
    stop
    start
  end

  # Creates and returns an MPD client to the MPD instance for this Channel.
  #
  # Returns an MPD client object.
  def connect
    return @connection if @connection && @connection.connected?

    @connection = MPD.new('localhost', mpd_port)
    @connection.connect
    @connection
  rescue Errno::ECONNRESET
    start
  rescue Errno::ECONNREFUSED
    start
  end

  # Returns an MPD client attached to the mpd process for this channel.
  #
  # Returns an MPD client object.
  def mpd
    connect
  end

  # Add a song to the end of the Channel's queue.
  #
  # song - The Song instance to add to the Channel's queue.
  # user - The User that requested this song (can be nil if auto-played).
  #
  # Returns the Queue.
  def add(song,user)
    mpd.add(song.path)

    if user
      user.play!(song)
    else
      SongPlay.create(:song_path => song.path, :user => nil)
    end
    queue
  end

  # Finds all the songs in the Channel's queue that we're looking for and removes
  # them.
  #
  # song - The Song instance to remove from the Channel's queue.
  #
  # Returns the queue.
  def remove(song,user)
    positions = []
    queue.each_with_index do |queued_song, i|
      positions << (i) if song.path == queued_song.path
    end

    positions.each { |position| mpd.delete(position) }

    queue
  end

  # Get the current playing song.
  #
  # Returns the current Song.
  def now_playing
    if record = mpd.queue.first
      Song.new(:path => record.file)
    end
  end

  # Clears the Channel's queue.
  #
  # Returns nothing.
  def clear
    mpd.clear
  end

  # List all of the songs in the Channel's queue.
  #
  # Returns an Array of Songs.
  def queue
    results = ActiveSupport::Notifications.instrument("queue.mpd") do
      mpd.queue
    end

    results.map do |result|
      Song.new(:path => result.file)
    end
  end

  # Sets the ports that the MPD for this channel will run on.
  #
  # Returns nothing.
  def set_ports
    unless self.mpd_port
      mpd_port = 6600 + Channel.count
      while Channel.where(:mpd_port => mpd_port).count > 0 do
        mpd_port += 1
      end
      self.mpd_port = mpd_port
    end

    unless self.httpd_port
      httpd_port = 8000 + Channel.count
      while Channel.where(:httpd_port => httpd_port).count > 0 do
        httpd_port += 1
      end
      self.httpd_port = httpd_port
    end
  end

  # Returns the path to the config directory for this channel.
  #
  # This is the directory that will hold things like the mpd's log, pid, and
  # config file.
  #
  # Returns String.
  def config_directory
    File.join(Rails.root, 'tmp', 'channels', "channel-#{id}")
  end

  # Returns the path to the config file for this channel's MPD.
  #
  # Returns String.
  def config_path
    File.join(config_directory, 'mpd.conf')
  end

  # Writes out the mpd.conf config file for this channel's MPD.
  #
  # Returns nothing.
  def write_config
    template_path = File.join(Rails.root, 'templates', 'mpd.conf.erb')

    opts = OpenStruct.new(:channel_name => name,
                          :httpd_port => httpd_port,
                          :mpd_port => mpd_port,
                          :music_path => Play.music_path,
                          :stream_bitrate => Play.config['mpd']['stream_bitrate'],
                          :system_audio => Play.system_audio,
                          :channel_config_directory => config_directory,
                          :global_mpd_path => Play.global_mpd_config_path,
                          )

    template = open(template_path, 'r') {|f| f.read}

    FileUtils.mkdir_p(config_directory)
    File.open(config_path, 'w') {|f| f.write(ERB.new(template).result(opts.instance_eval {binding})) }
  end

  # Hash representation of the Channel.
  #
  # Returns a Hash.
  def to_hash
    { :name => name,
      :color => color,
      :now_playing => nil,
      :slug => id
    }
  end

end
