require File.expand_path("../helper", __FILE__)

context "Api" do

  test "/play" do
    Player.expects(:play).returns(true)
    put "/play"
  end

  test "/pause" do
    Player.expects(:pause).returns(true)
    put "/pause"
  end

end
