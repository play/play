require File.expand_path("../../helper", __FILE__)

context "api/library" do

  setup do
    $redis.flushdb
    @song = Song.new \
              :artist  => 'Justice',
              :name    => 'Stress',
              :album   => 'Cross',
              :song_id => 'xyz'
    @user = User.create 'holman', 'zach@example.com'

    app.any_instance.stubs(:current_user).returns(@user)
    Play::Queue.stubs(:queued?).returns(false)
  end

  test "/search" do
    Player.expects(:search).returns([@song])
    get "/search", :q => 'Stress'
    song = parse_json(last_response.body.strip)[:songs].first

    assert_equal @song.name, song[:name]
    assert_equal @song.artist, song[:artist]
    assert_equal @song.album, song[:album]
  end

  test "/user/holman" do
    Song.stubs(:find).returns(@song)
    @user.star(@song)
    get "/user/holman"

    song = parse_json(last_response.body.strip)[:songs].first

    assert_equal @song.name, song[:name]
    assert_equal @song.artist, song[:artist]
    assert_equal @song.album, song[:album]
  end

  test "add a star" do
    Play::App.any_instance.stubs(:current_user).returns(@user)
    Song.stubs(:find).returns(@song)
    post "/star", :id => @song.id

    assert last_response.ok?
  end

  test "delete a star" do
    Play::App.any_instance.stubs(:current_user).returns(@user)
    Song.stubs(:find).returns(@song)
    delete "/star", :id => @song.id

    assert last_response.ok?
  end

  test "ratings" do
    Play::App.any_instance.stubs(:current_user).returns(@user)

    @trending = Song.new \
              :artist  => 'Carly Rae Jeppsen',
              :name    => 'Call Me Maybe',
              :album   => 'Call Me Maybe',
              :song_id => 'cmm',
              :id      => 'cmm'

    @pop = Song.new \
              :artist  => 'Old and Busted',
              :name    => 'Unpopular',
              :album   => 'Song',
              :song_id => 'bad',
              :id      => 'bad'

    Song.stubs(:find).with('cmm').returns(@trending)
    Song.stubs(:find).with('bad').returns(@pop)

    # People really used to like Old and Busted.
    three_days_ago = Time.now - 3*24*60*60
    100.times do 
      History.star_song(@pop, three_days_ago)
    end

    two_days_ago = Time.now - 2*24*60*60

    # And a little less popular the next day.
    80.times do 
      History.star_song(@pop, two_days_ago)
    end

    # But this is crazy, a new contender
    40.times do 
      History.star_song(@trending, two_days_ago)
    end

    yesterday = Time.now - 24*60*60
    50.times do 
      History.star_song(@trending, yesterday)
    end

    # If we look at the past three days, the popular song should still win.
    get "/popular?days=3"

    songs = parse_json(last_response.body.strip)[:songs]

    song = songs.first
    assert_equal @pop.name, song[:name]
    assert_equal @pop.artist, song[:artist]
    assert_equal @pop.album, song[:album]
    assert_equal 180*History::STAR_WEIGHT, song[:score].to_i

    song = songs.last
    assert_equal @trending.name, song[:name]
    assert_equal @trending.artist, song[:artist]
    assert_equal @trending.album, song[:album]
    assert_equal 90*History::STAR_WEIGHT, song[:score].to_i

    # But the trending one is gaining steam and wins over the last two.
    get "/popular?days=2"
    songs = parse_json(last_response.body.strip)[:songs]

    song = songs.first
    assert_equal @trending.name, song[:name]
    assert_equal @trending.artist, song[:artist]
    assert_equal @trending.album, song[:album]
    assert_equal 90*History::STAR_WEIGHT, song[:score].to_i

    song = songs.last
    assert_equal @pop.name, song[:name]
    assert_equal @pop.artist, song[:artist]
    assert_equal @pop.album, song[:album]
    assert_equal 80*History::STAR_WEIGHT, song[:score].to_i

    # Now a bunch of people rebel and queue the old song.
    10.times do
      History.star_song(@pop, Time.now)
    end

    1.times do
      History.add(@pop, @user)
    end

    # Now it's on top of the charts again.
    get "/popular?days=2"
    songs = parse_json(last_response.body.strip)[:songs]

    song = songs.first
    assert_equal @pop.name, song[:name]
    assert_equal @pop.artist, song[:artist]
    assert_equal @pop.album, song[:album]
    assert_equal 90*History::STAR_WEIGHT+1, song[:score].to_i
  end

end
