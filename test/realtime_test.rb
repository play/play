require File.expand_path("../helper", __FILE__)

context "Realtime" do

  setup do
    @song = Song.new \
              :id     => 'xyz',
              :artist => 'Justice',
              :name   => 'Stress'
  end

  test "pusher credentials" do
    assert_nothing_raised do
      assert Pusher["test"].trigger!("test_event", "some valid data")
    end
  end

  test "push now_playing update" do
    assert Realtime.update_now_playing(@song)
  end

end
