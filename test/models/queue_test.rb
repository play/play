require File.expand_path("../../helper", __FILE__)

context "Queue" do
  setup do
    Play.client.clear
    @song = Song.new('Justice/Cross/Stress.mp3')
    @user = User.create(:login => 'holman')
    Play::Queue.add(@song,@user)
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
    Play.client.volume(0)
    Play.client.play
    song = Play::Queue.now_playing
    assert_equal @song.title, song.title
  end

  test "clears the queue" do
    assert_equal 1, Play::Queue.songs.size
    Play::Queue.clear
    assert_equal 0, Play::Queue.songs.size
  end

  test "adds a song" do
    # setup() handles adding

    assert_equal 1, Play::Queue.songs.size
  end

  test "removes a song" do
    Play::Queue.remove(@song,@user)

    assert_equal 0, Play::Queue.songs.size
  end
end