module Play
  module Api
    module ApiResponse

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

    end
  end
end
