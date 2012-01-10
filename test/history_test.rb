require File.expand_path("../helper", __FILE__)

context "History" do

  setup do
    $redis.flushdb
    @song = Song.new \
              :id     => '24',
              :name   => 'Stress',
              :artist => 'Justice',
              :album  => 'Cross'
  end

  test "adds" do
    #assert_equal 0, History.count
    #History.add(@song, 1)
    #assert_equal 1, History.count
  end

end
