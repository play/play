module Play
  # Client gives us a nice interface to `mpc`, and, through `mpc`, `mpd`.
  class Client
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

    # Current playing song
    #
    # Returns the path to the current song
    def current
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

    # Resume play
    #
    # Returns an Array of Strings.
    def play
      native :play
    end

    # Clear the current playlist
    #
    # Returns an Array of Strings.
    def clear
      native :clear
    end

    # Change the volume
    #
    # value - Volume value, can be [-+]num
    def volume(value)
      native :volumne, [value.to_s]
    end
  end
end
