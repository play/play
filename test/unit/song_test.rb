require File.expand_path("../../helper", __FILE__)

context "Song" do
  setup do
    @song = Song.new('Justice', 'Stress')
  end

  test "belongs to an artist" do
    artist = Artist.new('Justice')
    assert_equal artist, @song.artist
  end

  test "has an name" do
    assert_equal 'Stress', @song.name
  end

  test "has a path" do
    @song.path = '/path'
    assert_equal '/path', @song.path
    assert_equal '/path', Song.new('a','song','/path').path
  end
end