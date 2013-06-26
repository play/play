require 'test_helper'

class SongPlayTest < ActiveSupport::TestCase
  setup do
    @song = Song.make
  end

  test "belongs to a song" do
    play = SongPlay.new(:song_path => @song.path)
    assert_equal @song, play.song
  end
end
