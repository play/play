require File.expand_path("../../helper", __FILE__)

context "Album" do
  setup do
    @album = Album.new('Justice', 'Cross')
  end

  test "belongs to an artist" do
    artist = Artist.new('Justice')
    assert_equal artist, @album.artist
  end

  test "has an name" do
    assert_equal 'Cross', @album.name
  end

  test "has songs" do
    song = @album.songs.first
    assert_equal 1, @album.songs.size
    assert_equal 'Stress', song.title
  end
end