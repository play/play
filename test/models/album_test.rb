require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  setup do
    @album = Album.make
  end

  test "belongs to an artist" do
    artist = Artist.make(:name => 'Justice')
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
    assert_equal Album.new(:name => 'Cross', :artist => @album.artist),
                 Album.new(:name => 'Cross', :artist => @album.artist)
  end

  test "to_param" do
    artist = Artist.new(:name => 'Boys Noize')
    album  = Album.new(:artist => artist, :name => 'XTC / Ich R U Remixes - EP')
    assert_equal 'XTC %2F Ich R U Remixes - EP', album.to_param
  end

  test "to_hash" do
    album = Album.make
    album_hash = album.to_hash

    hash_keys = album_hash.keys
    assert_equal 5, hash_keys.size
    assert hash_keys.include?(:name)
    assert hash_keys.include?(:artist_name)
    assert hash_keys.include?(:artist_slug)
    assert hash_keys.include?(:slug)
    assert hash_keys.include?(:songs)
  end

end
