require File.expand_path("../../helper", __FILE__)

context "Song" do
  setup do
    @song = Song.new('Justice/Cross/Stress.mp3')
  end

  test "belongs to an artist" do
    artist = Artist.new('Justice')
    assert_equal artist, @song.artist
  end

  test "has an title" do
    assert_equal 'Stress', @song.title
  end

  test "has a path" do
    assert_equal 'Justice/Cross/Stress.mp3', @song.path
  end

  test "has an album" do
    assert_equal 'Cross', @song.album.name
  end
end