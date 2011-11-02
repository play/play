require 'helper'

context "Artist" do
  fixtures do
    @artist = Play::Artist.create(:name => "Justice")
    @song   = Play::Song.create(:title => "Stress", :artist => @artist)
    @user   = User.create
  end

  test "enqueueing ten songs" do
    Song.any_instance.expects(:enqueue!).with(@user).times(1)
    @artist.enqueue!(@user)
  end

end
