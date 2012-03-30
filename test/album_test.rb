require 'helper'

context "Album" do
  fixtures do
    @artist = Play::Artist.create(:name => "Justice")
    @album  = Album.create(:name => 'Cross', :artist => @artist)
    @song   = Play::Song.create(:title => "Stress",
                                :artist => @artist,
                                :album => @album,
                                :path => "/tmp/music/song.mp3")
    @user   = User.create
  end

  test "enqueueing songs" do
    Song.any_instance.expects(:enqueue!).with(@user).times(1)
    @album.enqueue!(@user)
  end

  test "lastfm_url" do
    Play.stubs(:config).returns({ 'lastfm_key' => "abcd1234" })

    album = Album.create(:artist => @artist, :name => nil)

    assert_nothing_raised do
      album.lastfm_url
    end
  end

  test "path" do
    assert_equal "/tmp/music", @album.path
  end

  test "zipped!" do
    assert @album.respond_to?(:zipped!)
  end

  test "zip_name" do
    assert @album.zip_name =~ /Justice/
  end

  test "zip_path" do
    assert @album.zip_path =~ /\.zip$/
  end

end
