require File.expand_path("../helper", __FILE__)

context "Song" do

  setup do
    @song = Song.new(:id => 'xyz', :artist => 'Justice', :name => 'Stress')
  end

  test "initializes on id" do
    Song.expects(:find).with('a ID').returns(@song)
    assert_equal 'Justice', Song.new('a ID').artist
  end

  test "initalizes on hash" do
    assert_equal 'xyz',     @song.id
    assert_equal 'Justice', @song.artist
    assert_equal 'Stress',  @song.name
  end

end