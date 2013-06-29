# Client gives us a nice interface to `mpc`, and, through `mpc`, `mpd`.
class Client
  # A native command to run on the `mpc` binary.
  #
  # Returns the String output of the command.
  def native(cmd, options = {})
    options = options.map(&:to_s)
    pipe = IO.popen(['mpc', "--port=#{port}", "--quiet", cmd.to_s, *options])
    output = pipe.readlines
    pipe.close
    output
  end

  # The port mpd runs on. Exists for the purpose of stubbing out in test.
  #
  # Returns a String.
  def port
    '6600'
  end

  # Can we talk to mpc and mpd?
  #
  # Returns a Boolean.
  def running?
    output = native :version
    !!(output.first =~ /mpd version/)
  end

  # Lists a particular type of information.
  #
  # options - An Array of Symbols or Strings to pass on to mpc.
  #
  # Returns an Array of Strings.
  def list(options)
    ActiveSupport::Notifications.instrument("list.mpd", :options => options) do
      options = [options] if !options.kind_of?(Array)
      native :list, options
    end
  end

  # List all the music in the music directory
  #
  # Returns Array of Strings.
  def listall
    native :listall
  end

  # Searches for a particular match. Fuzzy search.
  #
  # options - An Array of Symbols or Strings to pass on to mpc.
  #
  # Returns an Array of Strings.
  def search(options)
    ActiveSupport::Notifications.instrument("search.mpd", :options => options) do
      options = [options] if !options.kind_of?(Array)
      native :search, options
    end
  end

  # Finds a particular exact match.
  #
  # options - An Array of Symbols or Strings to pass on to mpc.
  #
  # Returns an Array of Strings.
  def find(options)
    ActiveSupport::Notifications.instrument("find.mpd", :options => options) do
      options = [options] if !options.kind_of?(Array)
      native :find, options
    end
  end

  # Displays a playlist.
  #
  # Returns an Array of Strings.
  def playlist
    ActiveSupport::Notifications.instrument("playlist.mpd") do
      native :playlist, ["-f","%file%"]
    end
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
    ActiveSupport::Notifications.instrument("now_playing.mpd") do
      (native :current, ["-f","%file%"]).first
    end
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
end
