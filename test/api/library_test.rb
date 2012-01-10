require File.expand_path("../../helper", __FILE__)

context "api/library" do

  setup do
    @song = Song.new \
              :artist  => 'Justice',
              :name    => 'Stress',
              :album   => 'Cross',
              :song_id => 'xyz'
    @user = User.create 'holman', 'zach@example.com'
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

  test "add a star" do
    Play::App.any_instance.stubs(:current_user).returns(@user)
    Song.stubs(:find).returns(@song)
    delete "/star", :id => @song.id

    assert last_response.ok?
  end

end
