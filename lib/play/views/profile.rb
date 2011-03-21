module Play
  module Views
    class Profile < Layout
      def title
        @user ? @user.name : "Profile"
      end
    end
  end
end
