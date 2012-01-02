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
        Player.paused?
      end

      def now_playing
        Player.now_playing
      end

      def login
        @login
      end

      def song_list
        ember :song
      end

    private

      # Loads an ember.js mustache template.
      def ember(file)
        path = File.expand_path("app/frontend/templates/#{file}.html")
        File.read(path)
      end

    end
  end
end
