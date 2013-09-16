class Channel < ActiveRecord::Base
  attr_accessible :mpd_port, :httpd_port, :color, :name

  has_many :users

  before_save :set_ports
  after_save :write_config, :restart

  # ActiveRecord callbacks
  # ----------------------

  def set_ports
    # This is slow but that's OK, how often are you going to create channels?
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

  def write_config
    unless self.config_path
      self.config_path = "#{RAILS_ROOT}/tmp/mpd-#{self.id}/mpd.conf"
      self.save
    end
  end
  
  def start
    write_config
    `mpd #{config_path} > /dev/null 2>&1`
  end

  def stop
    `mpd #{config_path} --kill > /dev/null 2>&1`
  end

  def restart
    stop
    start
  end

  # MPD
  # ---
  def mpd
    return @connection if @connection && @connection.connected?

    @connection = MPD.new('localhost', mpd_port)
    @connection.connect
    @connection
  rescue Errno::ECONNREFUSED
    puts "Can't hit the music server. Make sure it's running."
  end

  def config_root_path
    File.join(Play.config['mpd']['config_root_path'], "channel-#{id}")
  end

  def config_path
    File.join(config_root_path, 'mpd.conf')
  end

  def write_config
    template_path = File.join(Rails.root, 'templates', 'mpd.conf.erb')

    opts = OpenStruct.new(:channel_name => name,
                          :httpd_port => httpd_port,
                          :mpd_port => mpd_port,
                          :music_path => Play.config['mpd']['music_path'],
                          :stream_bitrate => Play.config['mpd']['stream_bitrate'],
                          :system_audio => Play.config['mpd']['system_audio'],
                          :mpd_config_root_path => Play.config['mpd']['config_root_path'],
                          :channel_config_root_path => config_root_path
                          )

    template = open(template_path, 'r') {|f| f.read}

    # ensure path exists
    FileUtils.mkdir_p(config_root_path)

    File.open(config_path, 'w') {|f| f.write(ERB.new(template).result(opts.instance_eval {binding})) }
  end

end
