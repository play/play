# Sets Play up to be used by its friendly friends.
module Play

  # Public: The config located in config/play.yml.
  #
  # Returns an OpenStruct so you can chain methods off of `Play.config`.
  def self.config
    OpenStruct.new \
      :secret        => yaml['gh_secret'],
      :client_id     => yaml['gh_key'],
      :stream_url    => yaml['stream_url'],
      :office_url    => yaml['office_url'],
      :hostname      => yaml['hostname'],
      :pusher_app_id => yaml['pusher_app_id'],
      :pusher_key    => yaml['pusher_key'],
      :pusher_secret => yaml['pusher_secret']
  end

private

  # Load the config YAML.
  #
  # Returns a memoized Hash.
  def self.yaml
    if File.exist?('config/play.yml')
      @yaml ||= YAML.load_file('config/play.yml')
    else
      {}
    end
  end

end
