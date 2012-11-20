module Play
  # Client gives us a nice interface to `mpc`, and, through `mpc`, `mpd`.
  class Client

    # Convenience for configuring mpd.
    #
    # Returns self.
    def config
      yield self
      self
    end

    # A native command to run on the `mpc` binary.
    #
    # Returns the String output of the command.
    def native(cmd, options = {})
      options = options.map(&:to_s)
      output = IO.popen(['mpc', "--port=#{port}", "--quiet", cmd.to_s, *options])
      output.readlines
    end

    # The port mpd runs on. Exists for the purpose of stubbing out in test.
    #
    # Returns a String.
    def port
      '6600'
    end

    # Lists a particular type of information.
    #
    # options - An Array of Symbols or Strings to pass on to mpc.
    #
    # Returns an Array of Strings.
    def list(options)
      options = [options] if !options.kind_of?(Array)
      native :list, options
    end

    # List all the songs in the music directory.
    #
    # file - path relative to music directory.
    def listall(file=nil)
      native :listall, [file].compact
    end

    # Searches for a paricular match.
    #
    # options - An Array of Symbols or Strings to pass on to mpc.
    #
    # Returns an Array of Strings.
    def search(options)
      options = [options] if !options.kind_of?(Array)
      native :search, options
    end

    # Displays a playlist.
    #
    # Returns an Array of Strings.
    def playlist
      native :playlist, ["-f","%file%"]
    end

    # Clears a playlist.
    #
    # Returns an Array of Strings.
    def clear
      native :clear
    end

    # Current playing song.
    #
    # Returns the path to the current song.
    def now_playing
      (native :current, ["-f","%file%"]).first
    end

    # Adds a file to a playlist
    #
    # options - An Array of Symbols or Strings to pass on to mpc.
    #
    # Returns an Array of Strings.
    def add(options)
      options = [options] if !options.kind_of?(Array)
      native :add, options
    end

    # Resume play.
    #
    # Returns an Array of Strings.
    def play
      native :play
    end

    # Clear the current playlist.
    #
    # Returns an Array of Strings.
    def clear
      native :clear
    end

    # Removes a song from the playlist.
    #
    # position - The Integer position of a song in the current playlist.
    #
    # Returns nothing.
    def remove(position)
      native :del, [position]
    end

    # Change the volume.
    #
    # value - Volume value, can be [-+]num.
    def volume(value)
      native :volume, [value.to_s]
    end

    def method_missing(meth, *args, &block)
      if command = meth.to_s.match(/(\w+)=$/)
        native command[1], args
      else
        super
      end
    end

  end
end
