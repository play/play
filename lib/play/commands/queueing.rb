module Play
  module Commands
    class Queueing

      def self.help
        items = []
        items << "### Queueing ###"
        items << "play artist <artist> - Queue up three songs from a given artist."
        items << "play album <album> by <artist> - Queue up an entire album."
        items << "play song <song> by <artist> - Queue up a particular song."
        items << "play something I like - Queue up some of your starred songs."
        items << "play something <user> likes - Queue up some starred songs from someone else."
        items << "I like this song - Tell Play you like this song."
      end

      def self.process_command(command, channel, user)
        case command
        when /play artist (.*)/i
          artist_name = $1
          artist = Artist.new(:name => artist_name)

          songs = artist.songs.sample(3)

          if songs.any?
            Play::Commands.queue_songs(channel, user, songs)
          else
            "Can't find any songs by #{artist_name} ¯\_(ツ)_/¯"
          end
        when /play album (.*) by (.*)/i
          album_name = $1
          artist_name = $2

          artist = Artist.new(:name => artist_name)
          album = artist.albums.select { |album| album.name.downcase == album_name.downcase }.first if artist

          if album
            Play::Commands.queue_songs(channel, user, album.songs)
          else
            %{Couldn't find album "#{album_name}" by #{artist_name} ;_;}
          end
        when /play song (.*) by (.*)/i
          song_name = $1
          artist_name = $2

          artist = Artist.new(:name => artist_name)
          song = artist.songs.find{|song| song.title.downcase == song_name.downcase} if artist

          if song
            Play::Commands.queue_song(channel, user, song)
          else
            %{Can't find "#{song_name}" by #{artist_name}}
          end
        when /(play (songs|something) I like)|(play the good shit)/i
          songs = user.likes.limit(3).order('rand()').collect(&:song)
          Play::Commands.queue_songs(channel, user, songs)
        when /play (songs|something) (.*) likes/i
          user_name = $2
          other_user = User.where(:login => user_name).first
          if other_user
            songs = other_user.likes.limit(3).order('rand()').collect(&:song)
            Play::Commands.queue_songs(channel, user, songs)
          else
            "Who dat?"
          end
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

    end
  end
end
