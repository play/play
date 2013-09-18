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
    connect
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

  rescue Errno::ECONNREFUSED
    start
  end

  # Returns an MPD client attached to the mpd process for this channel.
  #
  # Returns an MPD client object.
  def mpd
    connect
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
                          :system_audio => Play.config['mpd']['system_audio'],
                          :channel_config_directory => config_directory,
                          :global_mpd_path => Play.global_mpd_config_path,
                          )

    template = open(template_path, 'r') {|f| f.read}

    FileUtils.mkdir_p(config_directory)
    File.open(config_path, 'w') {|f| f.write(ERB.new(template).result(opts.instance_eval {binding})) }
  end

end
