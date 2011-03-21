module Play
  module Views
    class ArtistSongs < Layout
      def title
        @artist.name
      end
    end
  end
end
