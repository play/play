class Channel < ActiveRecord::Base
  has_many :users

  def write_config
    # write out config based on mpd_port, httpd_port, and config_path
  end

  def start
    # start this channel's mpd instance
  end

  def stop
    # shut down this channel's mpd instance
  end

end
