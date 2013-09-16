class Channel < ActiveRecord::Base
  has_many :users
  
  attr_accessible :mpd_port, :httpd_port, :color, :name

  def start
    # start this channel's mpd instance
  end

  def stop
    # shut down this channel's mpd instance
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
