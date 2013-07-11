require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.make!
  end

  test "has attributes" do
    assert_equal 'holman', @user.login
  end

  test "has plays" do
    assert_equal 0, @user.plays.count
  end

  test "plays a song" do
    @user.play!(Song.make)
    assert !@user.plays.empty?
  end

  test "liked songs" do
    @user.like('Justice/Cross/Stress.mp3')

    assert @user.liked_songs.is_a?(Array)
    assert @user.liked_songs.first.is_a?(Song)
  end

  test "liked songs can paginate" do
    @user.like('Justice/Cross/Stress.mp3')
    @user.like('Justice/Cross/Yes.mp3')
    @user.like('Justice/Cross/No.mp3')

    songs = @user.liked_songs(1, 2)
    assert_equal 2, songs.size

    songs = @user.liked_songs(2, 2)
    assert_equal 1, songs.size
  end

  test "can like a song" do
    @user.like('any/song.mp3')

    assert_equal 1, @user.likes.count
  end

  test "clears likes" do
    @user.like('any/song.mp3')
    assert_equal 1, @user.likes.count

    @user.unlike('any/song.mp3')
    assert_equal 0, @user.likes.count
  end

  test "likes a particular song" do
    song = Song.make
    @user.like(song.path)
    assert @user.likes?(song)

    song = Song.make(:path => 'something/else')
    assert !@user.likes?(song)
  end

  test "has a gravatar" do
    assert_equal '5658ffccee7f0ebfda2b226238b1eb6e', @user.gravatar_id
  end

  test "generates a new token" do
    old_token = @user.token
    @user.generate_token
    assert_not_equal old_token, @user.token
  end

end
