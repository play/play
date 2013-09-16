class Channel < ActiveRecord::Base
  has_many :users

  before_save :set_ports
  after_save :write_config, :restart_mpd

  # Hooks
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

  def restart_mpd
  end

  def start
    # start this channel's mpd instance
  end

  def stop
    # shut down this channel's mpd instance
  end

end
