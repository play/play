require File.expand_path("../helper", __FILE__)

context "Album" do

  setup do
  end

  test "initializes" do
    album = Album.new('Cross','Justice')

    assert_equal 'Cross',   album.name
    assert_equal 'Justice', album.artist
  end

end
