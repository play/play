require File.expand_path("../../helper", __FILE__)

context "Queue" do
  setup do
    Play.client.clear
    @song = Song.new('Justice/Cross/Stress.mp3')
    Play::Queue.add(@song)
  end

  test "has songs" do
    song = Play::Queue.songs.first
    assert_equal 1, Play::Queue.songs.size
    assert_equal 'Stress', song.title
  end

  test "has songs" do
    song = Play::Queue.songs.first
    assert_equal 1, Play::Queue.songs.size
    assert_equal 'Stress', song.title
  end

  test "can get the current song" do
    Play.client.play
    Play.client.volume(0)
    song = Play::Queue.now_playing
    assert_equal @song.title, song.title
  end
end
