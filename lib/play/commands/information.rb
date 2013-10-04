module Play
  module Commands
    class Information

      def self.help
        items = []
        items << "### Info ###"
        items << "what's playing? - Shows the currently playing song."
        items << "what's next? - Shows the next song in the queue."
        items << "I want this song - Shows a download link for the current song."
        items << "I want this album - Shows a download link for the current album."
      end

      def self.process_command(command, channel, user)
        case command
        when /^sup|what'?s playing/i
          if song = channel.now_playing
            %{Now playing "#{song.title}" by #{song.artist_name}, from "#{song.album_name}"}
          else
            channel.autoqueue(3)
            song = channel.now_playing
            channel.mpd.play
            %{Yikes! Nothing was queued so I added a couple songs. First up: #{song.title}" by #{song.artist_name}, from "#{song.album_name}}
          end
        when /what'?s next/i
          if song = channel.up_next
            %{Now playing "#{song.title}" by #{song.artist_name}, from "#{song.album_name}"}
          else
            channel.autoqueue(Channel::MIN_QUEUE_SIZE - 1)
            song = channel.up_next
            %{Schnikes! Nothing was up next so I queued a couple songs. Next up: #{song.title} by #{song.artist_name}, from "#{song.album_name}}
          end
        when /I want this song|gimme dat/i
          if song = channel.now_playing
            %{Pretty rad, innit? Grab it for yourself: #{Rails.application.routes.url_helpers.song_download_url(song.path, :host => Play.request_host)}}
          else
            %{lol, there's nothing playing}
          end
        when /I want this album/i
          if song = channel.now_playing
            if song.album_name
              "dope beats available here: #{Rails.application.routes.url_helpers.album_download_url(:artist_name => song.artist_name, :name => song.album_name, :host => Play.request_host)}"
            else
              %{"#{song.title}" by #{song.artist_name} isn't actually part of an album. Maybe you want just this song instead?}
            end
          else
            %{lol, there's nothing playing}
          end
        end
      end

    end
  end
end
