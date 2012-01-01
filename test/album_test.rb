require File.expand_path("../helper", __FILE__)

context "Album" do

  setup do
  end

  test "initializes" do
    album = Album.new('xyz')
    assert_equal 'xyz', album.id
  end

end
