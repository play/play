require 'open-uri'

module Play
  class Speaker
    attr_reader :name, :host, :port

    def initialize(dnssd_reply)
      @name = dnssd_reply.name
      @host = dnssd_reply.target
      @port = dnssd_reply.port
    end

    # Returns a hash representing the status of the speaker.
    #
    # KEYS
    # volume:      the current volume of the speaker (0-100).
    # now_playing: A String showing the arist - song - album that is currently
    #              playing.
    #
    # Returns a Hash.
    def status
      request('/status')
    end

    # Returns the current volume
    #
    # Returns an Integer.
    def volume
      status['volume']
    end

    # Sets the volume of the speaker
    #
    # level: integer between 1 and 100
    #
    # Returns nothing.
    def set_volume(level)
      request('/volume', 'POST', {'level' => level})
    end

    # Mutes the speaker
    #
    # Returns nothing.
    def mute
      request('/mute', 'POST')
    end

    # Unmutes the speaker
    #
    # Returns nothing.
    def unmute
      request('/unmute', 'POST')
    end

    # Returns the identifier of the speaker.
    #
    # Returns a String.
    def slug
      name
    end

    # Hash representation of the speaker.
    #
    # Returns a Hash.
    def to_hash
      { :name => name,
        :host => host,
        :port => port,
        :volume => volume,
        :slug => slug
      }
    end

    private

    # Makes a request to the remote speaker.
    #
    # Returns a String.
    def request(path, method='GET', params={})
      url = "http://#{host}:#{port}" + path

      command = 'curl --insecure --silent '
      command << %{-d "#{params.to_query}"} if method =~ /POST/i
      command << %{ "#{url}"}
      JSON.parse(`#{command}`)
    end

  end
end
