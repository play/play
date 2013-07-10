require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  setup do
    @artist = Artist.make
  end

  test "can show all artists" do
    assert_includes     Artist.all, @artist
    assert_not_includes Artist.all, Artist.make(:name => "Zach Holman's Fuzzy Bears of Detroit")
  end

  test "knows bout equivalence" do
    assert Artist.new(:name => 'Justice') == Artist.new(:name => 'Justice')
    assert Artist.new(:name => 'Justice') != Artist.new(:name => 'wat')
  end

  test "has songs" do
    assert_includes @artist.songs, Song.make
  end

  test "to_param" do
    artist = Artist.make(:name => 'Count Basie / Duke Ellington')
    assert_equal 'Count Basie %2F Duke Ellington', artist.to_param
  end

  test "to_hash" do
    artist = Artist.make
    artist_hash = artist.to_hash

    hash_keys = artist_hash.keys
    assert_equal 2, hash_keys.size
    assert hash_keys.include?(:name)
    assert hash_keys.include?(:slug)
  end

end
