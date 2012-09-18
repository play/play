require File.expand_path("../../helper", __FILE__)

context "Artist" do
  include Helpers

  test "name_from_path" do
    assert_equal 'Stress', name_from_path('/path/to/Justice/Stress.m4a')
  end

  test "song_from_tuple" do
    tuple = "Justice :: Stress :: /path/to/Stress"
    song = song_from_tuple(tuple)

    assert_equal 'Justice',         song.artist.name
    assert_equal 'Stress',          song.name
    #assert_equal '/path/to/Stress', song.path
  end
end