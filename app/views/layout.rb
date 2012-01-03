module Play
  module Views
    class Layout < Mustache

      def playing?
        !Player.paused?
      end
      
      def now_playing
        Player.now_playing
      end

    end
  end
end
