module Play
  module Views
    class AlbumSongs < Layout
      def album_id
        @album.id
      end

      def title
        "#{@album.name}"
      end
    end
  end
end
