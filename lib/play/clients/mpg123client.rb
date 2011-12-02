module Play
  class Mpg123Client < Client
    # Cause the client to play a song
    #
    # Returns nothing
    def self.play(song_path)
      system("mpg123", song_path)
    end

    # The temp file we use to signify whether Play should be paused.
    #
    # Returns the String path of the pause file.
    def self.pause_path
      '/tmp/play_is_paused'
    end

    # "Pauses" a client by stopping currently playing songs and setting up the
    # pause temp file.
    # 
    # Returns nothing.
    def self.pause
      paused? ? `rm -f #{pause_path}` : `touch #{pause_path}`    
      `killall mpg123 > /dev/null 2>&1`
    end

    # Are we currently paused?
    #
    # Returns the Boolean value of whether we're paused.
    def self.paused?
      File.exist?(pause_path)
    end

    # Are we currently playing? Look at the process list and check it out.
    #
    # Returns true if we're playing, false if we aren't.
    def self.playing?
      `ps aux | grep mpg123 | grep -v grep | wc -l | tr -d ' '`.chomp != '0'
    end

    # Stop the music, and stop the music server.
    #
    # Returns nothing.
    def self.stop
      `killall mpg123 > /dev/null 2>&1`
      `ps ax | grep "play -d" | grep -v grep`.split("\n").size.times do
        `kill $(ps ax | grep "play -d" | grep -v grep | cut -d ' ' -f 1)`
      end
    end

    # Say things over the speakers, lol.
    #
    # Returns nothing.
    def self.say(msg)
      return unless msg
      system("echo '#{msg}' | festival --tts")
    end

    # Set the volume level of the client.
    #
    #   number - The Integer volume level. This should be a number between 0
    #            and 10, with "0" being "muted" and "10" being "real real loud"
    #
    # Returns nothing.
    def self.volume(number)
      volume = number.to_i * 10
      system "amixer set Master #{volume}% > /dev/null 2>&1"
    end
  end
end
