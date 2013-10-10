module Play
  module Api
    module ApiResponse

      def channel_response(channel, user)
        channel_hash = channel.to_hash
        song = channel.now_playing
        if song
          song.liked = user.likes?(song)
          channel_hash[:now_playing] = song.to_hash
        end

        channel_hash
      end

      def channels_response(channels, user)
        {:channels => channels.collect{|c| channel_response(c, user)}}
      end

      def song_response(song, user)
        return nil unless song

        song.liked = user.likes?(song)
        song.to_hash
      end

      def songs_response(songs, user)
        {:songs => songs.collect{|s| song_response(s, user)}}
      end

      def artist_response(artist, user)
        artist.to_hash
      end

      def album_response(album, user)
        album.songs.each {|song| song.liked = user.likes?(song) }
        album.to_hash
      end

      def albums_response(albums, user)
        {:albums => albums.collect{|a| album_response(a, user)}}
      end

      def speaker_response(speaker)
        speaker.to_hash
      end

      def speakers_response(speakers)
        {:speakers => speakers.collect{|s| speaker_response(s)}}
      end

    end
  end
end
