require File.expand_path("../helper", __FILE__)

context "Api" do

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
