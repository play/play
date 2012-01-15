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

  test "returns a given amount" do
    History.add(@song, @user)
    History.add(@song, @user)
    History.add(@song, @user)

    last = History.last(3)
    assert 3, last.size

    last = History.last
    assert 1, last.size
  end

end