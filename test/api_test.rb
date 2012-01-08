require File.expand_path("../helper", __FILE__)

context "Api" do

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

  test "/queue/add with ID" do
    Play::Queue.expects(:add_song).returns(true)
    Song.expects(:find).returns(nil)

    post "/queue/add", :id => 'xzy'
  end

  test "/queue/add without ID" do
    Play::Queue.expects(:add_song).returns(true)
    Song.expects(:new).returns(nil)

    post "/queue/add", :artist => 'Justice', :name => 'Stress'
  end

end
