require 'helper'

context "Library" do
  fixtures do
  end

  test "fs_songs" do
    FileUtils.mkdir_p '/tmp/play/.hidden'
    FileUtils.touch '/tmp/play/.hidden/song_1'
    FileUtils.touch '/tmp/play/.song_1'
    FileUtils.touch '/tmp/play/song_1'
    FileUtils.touch '/tmp/play/song_2'
    assert_equal 2, Library.fs_songs('/tmp/play').size
  end
end
