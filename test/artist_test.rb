require File.expand_path("../helper", __FILE__)

context "Artist" do
  setup do
    @artist = Artist.new('Justice')
  end

  test "has artists" do
    assert_include     Artist.all, @artist
    assert_not_include Artist.all, Artist.new("Zach Holman's Fuzzy Bears of Detroit")
  end

  test "knows bout equivalence" do
    assert Artist.new('Justice') == Artist.new('Justice')
    assert Artist.new('Justice') != Artist.new('wat')
  end
end