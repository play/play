module Play
  module Views
    class AlbumDetails < Layout
      def artist
        @artist
      end

      def album
        @album
      end
      
      def songs
        @songs
      end
    end
  end
end