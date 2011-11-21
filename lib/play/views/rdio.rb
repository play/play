module Play
  module Views
    class Rdio < Layout
      def playback_token
        @playback_token
      end
      
      def track_id
        @track_id
      end
      
      def domain
        @domain
      end
    end
  end
end
