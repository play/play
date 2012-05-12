require File.expand_path("../../helper", __FILE__)

context "api/dj" do
  setup do
    @song = Song.new \
              :artist  => 'Justice',
              :name    => 'Stress',
              :album   => 'Cross',
              :song_id => 'xyz'
  end

  test "/dj" do
    true
  end
end