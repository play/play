require 'play/connection_pool'

class Channel < ActiveRecord::Base
  MIN_QUEUE_SIZE = 3
  attr_accessible :mpd_port, :httpd_port, :color, :name

  has_many :users
  has_many :song_plays, -> {order(:created_at => :asc) }


  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  validates_uniqueness_of :httpd_port, :on => :create, :message => "must be unique"
  validates_uniqueness_of :mpd_port, :on => :create, :message => "must be unique"

  after_create :start
  before_save :set_ports
  before_save :set_sorts
  before_destroy :stop


  # Starts the mpd server for this channel.
  #
  # This first writes out a fresh mpd.conf for the mpd process and then starts
  # it up, and then connects to the MPD.
  #
  # Returns an MPD client.
  def start
    write_config

    pid = fork do
      exec_pid = fork do
        mpd_pid = fork do
          STDIN.reopen("/dev/null")
          STDOUT.reopen("/dev/null")
          STDERR.reopen("/dev/null")

          exec "mpd '#{config_path}'"
        end
        File.open(pid_path, "w") { |fp| fp.write mpd_pid }
      end
      Process.waitpid(exec_pid)
      exit($?.exitstatus)
    end

    mpd_connection = connect

    if !Rails.env.test? && mpd

      # Set up mpd to natively consume songs
      mpd.repeat  = true
      mpd.consume = true

      # Scan for new songs just in case
      mpd.update

      # Play the tunes
      mpd.play
    end

    mpd_connection
  end

  # Stops the mpd server for this channel.
  #
  # Returns nothing.
  def stop
    mpd.kill
  end

  # Restarts the mpd server for this channel.
  #
  # Returns nothing.
  def restart
    stop
    start
  end

  # Plays the next song in the channel's queue.
  #
  # This first ensures we have the appropriate number of songs in the queue
  # before and after the skip to the next song.
  #
  # Returns nothing.
  def next
    future_queue_size = self.queue.size - 1
    autoqueue(MIN_QUEUE_SIZE - future_queue_size)
    mpd.next
  end

  # Creates and returns an MPD client to the MPD instance for this Channel.
  #
  # Returns an MPD client object.
  def connect
    @mpd_connection = ConnectionPool.instance.connection_for(self)
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
  def add(song,user=nil)
    mpd.add(song.path)

    SongPlay.create(:song_path => song.path, :user => user, :channel => self)

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

  # Get the next playing song.
  #
  # Returns the next Song.
  def up_next
    if record = mpd.queue[1]
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

  # Autoqueues N number of songs based on the rules.
  #
  # This method adds N number of songs to the queue. The SongPlay created is not
  # attributed to a user so that it appears as an automated queue.
  #
  # If the channels has < 50 manual queues, the music library will used as the
  # pool from which songs are chosen from at random. If the channel has > 50
  # manual queues, the list of manual queues will be used as pool. This way the
  # channel will gain a sort of motiff.
  #
  # number_of_songs: number of songs you want queued.
  #
  # Returns nothing.
  def autoqueue(number_of_songs)
    number_of_songs.times do
      if song_plays.manually_queued.count > 50
        # this channel has some history, queue from the past
        puts "Auto-queuing a previously queued song to this channel: #{name}"
        song = song_plays.manually_queued.sample.song
      else
        # this is new, queue from the library
        puts "Auto-queuing a song from the library to the channel: #{name}"
        song = Song.new(:path => Play.library.files[:file].sample)
      end

      add(song, nil)
      mpd.clearerror
      mpd.play
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

  # Assigns a sort value that will put it at de bottom ov de list
  def set_sorts
    unless self.sort
      max = Channel.maximum(:sort)
      self.sort = max ? max + 1 : 0
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

  # Returns the path to the pid file for this channel's MPD.
  #
  # Returns String.
  def pid_path
    File.join(config_directory, 'mpd.pid')
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
