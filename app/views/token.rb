module Play
  module Views
    class Token < Mustache

      def token
        @current_user.token
      end

      def back_to
        @back_to
      end

    end
  end
end
