require File.expand_path("../helper", __FILE__)

context "Artist" do
  setup do
    @artist = Artist.new('Justice')
  end

  test "knows its name" do
    assert_equal 'Justice', @artist.name
  end

  test "has many songs" do
    assert @artist.respond_to?(:songs)
  end

end
