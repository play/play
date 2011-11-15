module Play
  class Platform
    # Tests if currently running on Darwin.
    #
    # Returns true if platform is Darwin (Mac OS X), else false.
    def self.darwin?
      !!(RUBY_PLATFORM =~ /darwin/)
    end

    # Tests if currently running on Linux.
    #
    # Returns true if platform is Linux, else false.
    def self.linux?
      !!(RUBY_PLATFORM =~ /linux/)
    end

    # Tests if currently running on Windows.
    #
    # Returns true if platform is Windows, else false.
    def self.windows?
      !!(RUBY_PLATFORM =~ /mswin|mingw/)
    end

    # Gets the command used to play a music file for the current platform.
    #
    # Returns a String of the command.
    def self.play_command
      if darwin?
        'afplay'
      elsif linux?
        'mpg123'
      elsif windows?
        warn('You are using an unsupported operating system')
        exit(1)
      end
    end

    # Gets the command used to say something over the speakers on the current
    # platform.
    #
    # Returns a String of the command.
    # TODO: Find something like `say` for Linux.
    def self.say_command
      if darwin?
        'say'
      elsif linux?
        ''
      elsif windows?
        warn('You are using an unsupported operating system')
        exit(1)
      end
    end

    # Get the command used to change the volume on the current platform.
    #
    # number - An Integer of the volume to change to.
    #
    # Returns a String of the command.
    def self.volume_command(number)
      number = 10 if number > 10
      if darwin?
        "osascript -e 'set volume #{number}' 2>/dev/null"
      elsif linux?
        volume = number.to_i * 10
        "amixer set Master #{volume}%"
      elsif windows?
        warn('You are using an unsupported operating system')
        exit(1)
      end
    end
  end
end
