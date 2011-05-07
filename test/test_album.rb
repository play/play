require 'helper'

context "Album" do
  fixtures do
    @artist = Play::Artist.create(:name => "Justice")
    @album  = Album.create(:name => 'Cross', :artist => @artist)
    @song   = Play::Song.create(:title => "Stress",
                                :artist => @artist,
                                :album => @album)
    @user   = User.create
  end

  test "enqueueing songs" do
    Song.any_instance.expects(:enqueue!).with(@user).times(1)
    @album.enqueue!(@user)
  end

end
