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
          system("#{Platform.play_command}", Song.play_next_in_queue.path)
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
      `killall #{Platform.play_command} > /dev/null 2>&1`
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
      `ps aux | grep #{Platform.play_command} | grep -v grep | wc -l | tr -d ' '`.chomp != '0'
    end

    # Stop the music, and stop the music server.
    #
    # Returns nothing.
    def self.stop
      `killall #{Platform.play_command} > /dev/null 2>&1`
      `ps ax | grep "play -d" | grep -v grep`.split("\n").size.times do
        `kill $(ps ax | grep "play -d" | grep -v grep | cut -d ' ' -f 1)`
      end
    end

    # Say things over the speakers, lol.
    #
    # Returns nothing.
    def self.say(msg)
      system "#{Platform.say_command} #{msg}" if msg
    end

    # Set the volume level of the client.
    #
    #   number - The Integer volume level. This should be a number between 0
    #            and 10, with "0" being "muted" and "10" being "real real loud"
    #
    # Returns nothing.
    def self.volume(number)
      system "#{Platform.volume_command number}"
    end
  end
end
