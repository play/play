require File.expand_path("../helper", __FILE__)

context "Api" do

  setup do
    @song = Song.new \
          :id     => '24',
          :name   => 'Stress',
          :artist => 'Justice',
          :album  => 'Cross'
  end

  test "/queue/add with ID" do
    Play::Queue.expects(:add_song).returns(true)
    History.stubs(:add).returns(true)
    Song.expects(:find).returns(@song)

    post "/queue", :id => 'xzy'
  end

  test "/queue/add without ID" do
    Play::Queue.expects(:add_song).returns(true)
    History.stubs(:add).returns(true)
    Song.expects(:new).returns(@song)

    post "/queue", :artist => 'Justice', :name => 'Stress'
  end

end
