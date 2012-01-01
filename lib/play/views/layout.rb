module Play
  module Views
    class Layout < Mustache
      def queue_page
        request.env["REQUEST_URI"] =~ /\/$/ ? 'active' : ''
      end

      def history_page
        request.env["REQUEST_URI"] =~ /\/history$/ ? 'active' : ''
      end

      def profile_page
        request.env["REQUEST_URI"] =~ /\/#{@login}$/ ? 'active' : ''
      end

      def stream?
        !stream_url.blank?
      end

      def stream_url
        Play.config['stream_url']
      end

      def playing?
        #!Play.client.paused?
      end

      def login
        @login
      end
    end
  end
end
