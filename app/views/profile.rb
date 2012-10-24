module Play
  module Views
    class Profile < Layout
      def user
        @user
      end

      def login
        @user.login
      end

      def history
        @user.plays
      end
    end
  end
end