module Play
  module Commands
    class Queueing

      def self.help
        items = []
        items << "### Queueing ###"
        items << "play <artist|album|song> - Queue something up. Items are picked by the priority listed."
        items << "play <album|song> by <artist> - Queue something up by artist. Items are picked by the priority listed."
        items << "play artist <artist> - Queue up three songs from a given artist."
        items << "play album <album> by <artist> - Queue up an album by an artist."
        items << "play song <song> by <artist> - Queue up a particular song by an artist."
        items << "play something I like - Queue up some of your starred songs."
        items << "play something <user> likes - Queue up some starred songs from someone else."
        items << "I like this song - Tell Play you like this song."
      end

      def self.process_command(command, channel, user)
        case command
        when /play artist (.*)/i
          artist_name = $1
          artist = find_artist(artist_name)

          if artist
            queue_artist(channel, user, artist)
          else
            "Hmm, I don't know that artist."
          end


        when /play album (.*) by (.*)/i
          album_name = $1
          artist_name = $2

          album = find_album(artist_name, album_name)

          if album
            queue_album(channel, user, album)
          else
            %{Couldn't find album "#{album_name}" by #{artist_name} ;_;}
          end
        when /play song (.*) by (.*)/i
          song_name = $1
          artist_name = $2

          artist = find_artist(artist_name)
          song = artist.songs.find{|song| song.title.downcase == song_name.downcase} if artist

          if song
            Play::Commands.queue_song(channel, user, song)
          else
            %{Can't find "#{song_name}" by #{artist_name}}
          end
        when /play (.*) by (.*)/i
          input = $1
          artist_name = $2

          # queue an album
          songs_by_album_results = Play.library.send_command(:find, :album, input, :artist, artist_name)
          if songs_by_album_results.present?
            songs = songs_by_album_results.map do |result|
              Song.new(:path => result[:file])
            end

            return Play::Commands.queue_songs(channel, user, songs)
          end

          # queue a song
          song_result = Play.library.send_command(:find, :title, input, :artist, artist_name)
          if song_result.present?
            song = Song.new(:path => song_result.first[:file])
            return Play::Commands.queue_song(channel, user, song)
          end

          "Sorry, I couldn't find anything like that."
        when /(play (songs|something) I like)|(play the good shit)/i
          if user
            songs = user.likes.random(3).collect(&:song)
            if songs.present?
              Play::Commands.queue_songs(channel, user, songs)
            else
              "Oops, I don't know your taste. Like some songs on Play and I'll remember for next time."
            end
          else
            "I don't know who you are. Have you been to #{root_url(:host => Play.request_host)} yet?"
          end
        when /play (songs|something) (.*) likes/i
          user_name = $2
          other_user = User.where("lower(login) = ?", user_name).first
          if other_user
            songs = other_user.likes.random(3).collect(&:song)
            if songs.present?
              Play::Commands.queue_songs(channel, user, songs)
            else
              "Oops, I don't know their taste. Wait for them to like some songs on Play and I'll remember for next time."
            end
          else
            "Who dat?"
          end
        when /play (.*)/i
          # This is the loosey goosey command that will take an artist, album,
          # or song. We'll just look for things based on priority and queue them.
          #
          # Priority: Artist, Album, Song

          input = $1

          # queue an artist
          songs_by_artist_results = Play.library.send_command(:find, :artist, input)
          if songs_by_artist_results.present?
            songs = songs_by_artist_results.map do |result|
              Song.new(:path => result[:file])
            end

            return Play::Commands.queue_songs(channel, user, songs.sample(3))
          end

          # queue an album
          songs_by_album_results = Play.library.send_command(:find, :album, input)
          if songs_by_album_results.present?
            songs = songs_by_album_results.map do |result|
              Song.new(:path => result[:file])
            end

            return Play::Commands.queue_songs(channel, user, songs)
          end

          # queue a song
          song_result = Play.library.send_command(:find, :title, input)
          if song_result.present?
            song = Song.new(:path => song_result.first[:file])
            return Play::Commands.queue_song(channel, user, song)
          end

          "Sorry, I couldn't find anything like that."
        when /I (.* )?(like|star|love|dig) this( song)?/i
          if song = channel.now_playing
            if user.likes?(song)
              "I know."
            else
              user.like(song.path)
              %{You like #{song.artist_name}'s "#{song.title}", too? Awesome.}
            end
          else
            %{Uhh, nothing is playing! You're weird.}
          end
        end
      end

      def self.find_artist(artist_name)
        Artist.new(:name => artist_name)
      end

      def self.find_album(artist_name, album_name)
        artist = find_artist(artist_name)
        album = artist.albums.select { |album| album.name.downcase == album_name.downcase }.first if artist
      end


      def self.queue_artist(channel, user, artist)
        songs = artist.songs.sample(3)

        if songs.any?
          Play::Commands.queue_songs(channel, user, songs)
        else
          "Can't find any songs by #{artist.name} ¯\_(ツ)_/¯"
        end
      end

      def self.queue_album(channel, user, album)
        Play::Commands.queue_songs(channel, user, album.songs)
      end


    end
  end
end
