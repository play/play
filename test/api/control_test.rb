require File.expand_path("../../helper", __FILE__)

context "api/control" do

  setup do
    @song = Song.new \
              :artist  => 'Justice',
              :name    => 'Stress',
              :album   => 'Cross',
              :song_id => 'xyz'
    Play::Queue.stubs(:queued?).returns(false)
  end

  test "/now_playing" do
    Player.expects(:now_playing).returns(@song)
    get "/now_playing"
    response = parse_json(last_response.body.strip)

    assert_equal @song.name, response[:name]
    assert_equal @song.artist, response[:artist]
    assert_equal @song.album, response[:album]
  end

  test "/play" do
    Player.expects(:play).returns(nil)
    put "/play"
  end

  test "/pause" do
    Player.expects(:pause).returns(nil)
    put "/pause"
  end

  test "/next" do
    Player.expects(:play_next).returns(true)
    put "/next"
  end

  test "/previous" do
    Player.expects(:play_previous).returns(true)
    put "/previous"
  end

  test "/say" do
    msg = "Always with the rocks"
    Player.expects(:say).with(msg).returns(nil)
    post "/say", :message => msg
  end

end
