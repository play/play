module Play
  module Views
    class Token < Mustache

      def token
        @current_user.token
      end

    end
  end
end
