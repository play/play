module Play
  module Views
    class Layout < Mustache
      def current_login
        @current_user.login
      end
    end
  end
end