module Play
  module Views
    class NowPlaying < Layout
      def title
        "now playing"
      end

      def artist_name
        @song.artist_name
      end

      def song_title
        @song.title
      end
    end
  end
end
