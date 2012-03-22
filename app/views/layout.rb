module Play
  module Views
    class Layout < Mustache

      def login
        @current_user.login
      end

      def stream
        Play.config.stream_url
      end

      def now_playing
        Player.now_playing
      end

      def airfoil?
        Airfoil.enabled?
      end

    end
  end
end
