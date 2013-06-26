require 'test_helper'

class PlayQueueTest < ActiveSupport::TestCase
  setup do
    Play.client.clear
    @song = Song.make
    @user = User.make
    PlayQueue.add(@song,@user)
  end

  test "has songs" do
    song = PlayQueue.songs.first
    assert_equal 1, PlayQueue.songs.size
    assert_equal 'Stress', song.title
  end

  test "can get the current song" do
    Play.client.play
    song = PlayQueue.now_playing
    assert_equal @song.title, song.title
  end

  test "clears the queue" do
    assert_equal 1, PlayQueue.songs.size
    PlayQueue.clear
    assert_equal 0, PlayQueue.songs.size
  end

  test "adds a song" do
    # setup() handles adding

    assert_equal 1, PlayQueue.songs.size
  end

  test "adds a song without a user" do
    Play.client.clear
    PlayQueue.add(@song,nil)

    assert_equal 1, PlayQueue.songs.size
  end

  test "removes a song" do
    PlayQueue.remove(@song,@user)

    assert_equal 0, PlayQueue.songs.size
  end
end
