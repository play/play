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

      def login
        @login
      end
    end
  end
end
