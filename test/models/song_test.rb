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

  test "knows equivalence" do
    assert_equal Song.new('Justice/Cross/Stress.mp3'), @song
  end

  test "finds a song by any" do
    songs = Song.find([:any, 'justice'])
    assert_equal 1, songs.size
  end

  test "finds a song by its title" do
    songs = Song.find([:title, 'stress'])
    assert_equal 1, songs.size
  end

  test "can't find a song if it's not there" do
    songs = Song.find([:title, 'vancouver'])
    assert_equal 0, songs.size
  end

  test "artist name" do
    assert_equal 'Justice', @song.artist_name
  end

  test "album name" do
    assert_equal 'Cross', @song.album_name
  end
end