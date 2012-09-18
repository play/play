require File.expand_path("../../helper", __FILE__)

context "Queue" do
  setup do
    @song = Song.new('Justice', 'Stress', 'Justice/Cross/Stress.mp3')
    Play::Queue.add(@song)
  end

  test "has songs" do
    song = Play::Queue.songs.first
    assert_equal 1, Play::Queue.songs.size
    assert_equal 'Stress', song.name
  end
end