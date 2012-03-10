require File.expand_path("../../helper", __FILE__)

context "api/helpers" do
  include Helpers

  setup do
    @songs = [
      Song.new(:artist => 'Justice',
               :name => 'Stress',
               :album => 'Cross',
               :id => 'xyz'),
      Song.new(:artist => 'Deadmau5',
               :name => 'Strobe',
               :album => 'Skrillex covers',
               :id => 'xyza')
    ]
    @user = User.create 'holman', 'zach@example.com'
  end

  test "valid songs_as_json with valid parameters" do
    json = JSON.parse(songs_as_json(@songs, @user))
    result = json["songs"]

    assert_equal result[0].keys, ["id", "name", "artist", "album", "starred", "queued"]
    assert_equal 2, result.length

    @songs.each_with_index do |song, index|
      assert_equal song[:id], result[index]["id"]
      assert_equal song[:name], result[index]["name"]
      assert_equal song[:artist], result[index]["artist"]
      assert_equal song[:album], result[index]["album"]
      assert_equal false, result[index]["starred"]
      assert_equal false, result[index]["queued"]
    end
  end

end
