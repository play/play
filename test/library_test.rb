require 'helper'

context "Library" do
  fixtures do
  end

  test "imports a song" do
    Library.import_song('/tmp/path')
    assert_equal 1, Play::Song.count
  end

  test "fs_songs" do
    FileUtils.mkdir_p '/tmp/play'
    FileUtils.touch '/tmp/play/song_1'
    FileUtils.touch '/tmp/play/song_2'
    assert_equal 2, Library.fs_songs('/tmp/play').size
  end
end
