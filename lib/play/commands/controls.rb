module Play
  module Commands
    class Controls

      def self.help
        items = []
        items << "### Controls ###"
        items << "play - Start playing."
        items << "next - Plays the next song."
        items << "pause - Pause."
      end

      def self.process_command(command, channel, user)
        ## Control
        case command
        when /^play/i
          channel.mpd.play
          "You got it, playing"
        when /^pause/i
          channel.mpd.pause = true
          "You got it, pausing"
        when /^next/i
          channel.next
          song = channel.now_playing
          %{Now playing "#{song.title}" by #{song.artist_name}, from "#{song.album_name}"}
        end
      end

    end
  end
end
