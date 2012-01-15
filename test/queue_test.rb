require File.expand_path("../helper", __FILE__)

context "Queue" do
  setup do
    @song = Song.new \
              :id     => 'xyz',
              :artist => 'Justice',
              :name   => 'Stress'
  end

  test "nothing" do
    assert true
  end
end