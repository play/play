module Play
  module Views
    class AlbumSongs < Layout
      def title
        "#{@artist.name}: #{@album.name}"
      end
    end
  end
end
