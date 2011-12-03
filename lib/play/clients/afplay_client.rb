module Play
  class AfplayClient < Client
    # Cause the client to play a song
    #
    # Returns nothing
    def self.play(song_path)
      system("afplay", song_path)
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
      `killall afplay > /dev/null 2>&1`
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
      `ps aux | grep afplay | grep -v grep | wc -l | tr -d ' '`.chomp != '0'
    end

    # Stop the music, and stop the music server.
    #
    # Returns nothing.
    def self.stop
      `killall afplay > /dev/null 2>&1`
      `ps ax | grep "play -d" | grep -v grep`.split("\n").size.times do
        `kill $(ps ax | grep "play -d" | grep -v grep | cut -d ' ' -f 1)`
      end
    end

    # Say things over the speakers, lol.
    #
    # Returns nothing.
    def self.say(msg)
      return unless msg
      system "say #{msg}"
    end

    # Set the volume level of the client.
    #
    #   number - The Float volume level. This should be a number between 0
    #            and 10, with "0" being "muted" and "10" being "real real loud"
    #            System scale: 0-7
    #
    # Returns nothing.
    #
    # Get the volume level of the client (System returns in scale 0-100)
    #   no argument
    #
    # Returns Float (Scale 0-10)
    def self.volume(number = nil)
      if (volume == nil)
         volume = `osascript -e 'get output volume of (get volume settings)'`
         ((volume.to_f)/10)
      else
         vol = ((number.to_f)/7).round(1)
         system "osascript -e 'set volume #{vol}' 2>/dev/null"
      end
    end
  end
end
