require File.expand_path("../helper", __FILE__)

context "Player" do

  test "knows now_playing" do
    assert Player.respond_to?(:now_playing)
  end

end
