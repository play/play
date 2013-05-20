require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  setup do
    @artist = Artist.new('Justice')
  end

  test "can show all artists" do
    assert_include     Artist.all, @artist
    assert_not_include Artist.all, Artist.new("Zach Holman's Fuzzy Bears of Detroit")
  end

  test "knows bout equivalence" do
    assert Artist.new('Justice') == Artist.new('Justice')
    assert Artist.new('Justice') != Artist.new('wat')
  end

  test "has songs" do
    assert_include @artist.songs, Song.new('Justice/Cross/Stress.mp3')
  end
end