require 'singleton'

class ConnectionPool
  include Singleton

  def initialize
    @channels = {}
  end

  def connection_for(channel)
    conn = @channels[channel.id]
    return conn if conn && conn.connected?

    conn = MPD.new('localhost', channel.mpd_port)
    conn.connect
    @channels[channel.id] = conn
    conn
  end
end
