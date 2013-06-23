require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  setup do
    @album = Album.new('Justice', 'Cross')
  end

  test "belongs to an artist" do
    artist = Artist.new('Justice')
    assert_equal artist, @album.artist
  end

  test "has an name" do
    assert_equal 'Cross', @album.name
  end

  test "has songs" do
    song = @album.songs.first
    assert_equal 1, @album.songs.size
    assert_equal 'Stress', song.title
  end

  test "has a zip name" do
    assert_equal 'Justice - Cross.zip', @album.zip_name
  end

  test "has a zip path" do
    assert_equal '/tmp/play-zips/Justice - Cross.zip', @album.zip_path
  end

  test "==" do
    assert_equal Album.new('Justice', 'Cross'), Album.new('Justice', 'Cross')
  end

  test "to_param" do
    album = Album.new('Boys Noize', 'XTC / Ich R U Remixes - EP')
    assert_equal 'XTC %2F Ich R U Remixes - EP', album.to_param
  end
end
