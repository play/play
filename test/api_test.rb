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

  test "/say" do
    msg = "Always with the rocks"
    Player.expects(:say).with(msg).returns(nil)
    post "/say", :message => msg
  end

end
