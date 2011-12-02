module Play
  class MpcClient < Client
    # Have the client play a song
    #
    # Returns nothing
    def self.play(song_path)
      if `mpc playlist | wc -l`.to_i < 1
        if not system('mpc', 'add',
          song_path.gsub(/^#{Play.config['path']}\//,""))
          return # mpc didn't add the song, so just return, don't block
        end
      end
      `mpc play`
      `mpc idle` # self.play is expected to block, so wait for an event
    end

    # Cause the client to play the next song.
    #
    # Returns true if successful, else false.
    def self.next
      `mpc next`
    end

    # Pauses the client
    #
    # Returns nothing.
    def self.pause
      `mpc pause`
    end

    # Are we currently paused?
    #
    # Returns the Boolean value of whether we're paused.
    def self.paused?
      `mpc status`.include? '[paused]'
    end

    # Are we currently playing?
    #
    # Returns true if we're playing, false if we aren't.
    def self.playing?
      `mpc status`.include? '[playing]'
    end

    # Stop the music, and stop the music server.
    #
    # Returns nothing.
    def self.stop
      `mpc stop`
      `ps ax | grep "play -d" | grep -v grep`.split("\n").size.times do
        `kill $(ps ax | grep "play -d" | grep -v grep | cut -d ' ' -f 1)`
      end
    end
  end
end
