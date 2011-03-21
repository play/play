module Play
  module Views
    class ShowSong < Layout
      def title
        "#{@song.title} by #{@song.artist.name}"
      end

      def users
        @song.votes.group(:user_id).collect do |vote|
          vote.user
        end
      end

      def plays
        @song.votes.count
      end
    end
  end
end
