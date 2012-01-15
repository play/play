require File.expand_path("../helper", __FILE__)

context "Queue" do

  setup do
    @song = Song.new \
              :id     => 'xyz',
              :artist => 'Justice',
              :name   => 'Stress'
  end

  test "queued?" do
    Play::Queue.stubs(:songs).returns([@song])
    assert Play::Queue.queued?(@song)
  end

end