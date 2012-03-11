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
    json = JSON.parse(songs_as_json @songs, @user)
    songs = json["songs"]

    assert_equal ["songs"], json.keys
    assert_equal ["album", "artist", "id", "name", "queued", "starred"], songs[0].keys.sort
    assert_equal ["album", "artist", "id", "name", "queued", "starred"], songs[1].keys.sort
    assert_equal 2, songs.length

    @songs.each_with_index do |song, index|
      assert_equal song[:id], songs[index]["id"]
      assert_equal song[:name], songs[index]["name"]
      assert_equal song[:artist], songs[index]["artist"]
      assert_equal song[:album], songs[index]["album"]
      assert_equal false, songs[index]["starred"]
      assert_equal false, songs[index]["queued"]
    end
  end if ENV['CI'] != '1'

  test "songs_as_json with empty parameters" do
    json = JSON.parse(songs_as_json nil, nil)
    assert_equal ["songs"], json.keys
    assert_equal 0, json["songs"].length
  end

  test "songs_as_json with songs parameter only" do
    json = JSON.parse(songs_as_json @songs, nil)
    assert_equal ["songs"], json.keys
    assert_equal 0, json["songs"].length
  end

  test "songs_as_json with user parameter only" do
    json = JSON.parse(songs_as_json nil, @user)
    assert_equal ["songs"], json.keys
    assert_equal 0, json["songs"].length
  end

end
