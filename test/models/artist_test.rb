require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  setup do
    @artist = Artist.new('Justice')
  end

  test "can show all artists" do
    assert_includes     Artist.all, @artist
    assert_not_includes Artist.all, Artist.new("Zach Holman's Fuzzy Bears of Detroit")
  end

  test "knows bout equivalence" do
    assert Artist.new('Justice') == Artist.new('Justice')
    assert Artist.new('Justice') != Artist.new('wat')
  end

  test "has songs" do
    assert_includes @artist.songs, Song.make
  end

  test "to_param" do
    artist = Artist.new('Count Basie / Duke Ellington')
    assert_equal 'Count Basie %2F Duke Ellington', artist.to_param
  end
end
