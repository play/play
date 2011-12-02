module Play
  class Client
    # The main event loop for an audio client. It will loop through each song
    # in the queue, unless it's paused.
    #
    # Returns nothing.
    def self.loop
      while true
        ActiveRecord::Base.connection.reconnect!

        Signal.trap("INT") { exit! }  

        if paused?
          sleep(1)
        else
          song = Song.play_next_in_queue
          if song
            library = Play::Library.instance(song.library_type)
            library.play!(song) if library && library.enabled?
          end
        end
      end
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
      Play::Library.each do |library|
        library.stop!
      end
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
      Play::Library.each do |library|
        return true if library.playing?
      end
      false
    end
    
    def self.kill_each(val)
      `ps ax | grep "#{val}" | grep -v grep`.split("\n").size.times do
        `kill $(ps ax | grep "#{val}" | grep -v grep | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1)`
      end
    end
    
    def self.ps_count?(val)
      `ps aux | grep "#{val}" | grep -v grep | wc -l | tr -d ' '`.chomp != '0'
    end

    # Stop the music, and stop the music server.
    #
    # Returns nothing.
    def self.stop
      # shut down the service itself
      kill_each("play -d")
      
      Play::Library.each do |library|
        library.stop!
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
    #   number - The Integer volume level. This should be a number between 0
    #            and 10, with "0" being "muted" and "10" being "real real loud"
    #
    # Returns nothing.
    def self.volume(number)
      system "osascript -e 'set volume #{number}' 2>/dev/null"
    end
  end
end
