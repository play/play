require 'helper'

context "Play" do
  setup do
  end

  test "path" do
    Play.expects(:config).returns({'path' => '/tmp/play'})
    assert_equal '/tmp/play', Play.path
  end

  test "now playing" do
    @song = Play::Song.create
    @song.play!
    assert @song, Play.now_playing
  end
end
