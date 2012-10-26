module Play
  module Views
    class Profile < Layout
      def user
        @user
      end

      def login
        @user.login
      end

      def songs
        @songs
      end
    end
  end
end