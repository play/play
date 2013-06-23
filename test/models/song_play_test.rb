require 'test_helper'

class SongPlayTest < ActiveSupport::TestCase
  setup do
    @song = Song.new('Justice/Cross/Stress.mp3')
  end

  test "belongs to a song" do
    play = SongPlay.new(:song_path => 'Justice/Cross/Stress.mp3')
    assert_equal @song, play.song
  end
end
