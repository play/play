require File.expand_path("../helper", __FILE__)

context "History" do

  setup do
    $redis.flushdb
    @song = Song.new \
              :id     => '24',
              :name   => 'Stress',
              :artist => 'Justice',
              :album  => 'Cross'
    @user = User.create('holman', 'zach@github.com')
  end

  test "adds affect counts" do
    assert_equal 0, History.count
    assert_equal 0, History.count_by_song(@song)

    History.add(@song, @user)

    assert_equal 1, History.count
    assert_equal 1, History.count_by_song(@song)
  end

  test "user count returns zero, not nil" do
    song = Song.new({:id => 'nope'})
    assert_equal 0, History.count_by_song(song)
  end

  test "proper blame is attributed" do
    History.add(@song, @user)
    assert_equal @user.login, History.song_last_queued_by(@song)
    assert_equal @user.login, @song.last_queued_by
  end

  test "returns a given amount" do
    History.add(@song, @user)
    History.add(@song, @user)
    History.add(@song, @user)

    Song.stubs(:find).returns(@song)

    last = History.last(3)
    assert_equal 3, last.size

    last = History.last
    assert_equal 1, last.size
  end

end