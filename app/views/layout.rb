module Play
  module Views
    class Layout < Mustache
      def uri_prefix
        Play.uri_prefix
      end

      def current_login
        @current_user.login
      end

      def not_running?
        if !Play.client.running?
          "<div>The music server isn't running. Spin it up with <code>script/music start</code>.</div>"
        end
      end
    end
  end
end
