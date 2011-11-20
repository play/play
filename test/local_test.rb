require 'helper'

context "Local" do
  fixtures do
  end
  
  test "imports a song" do
    Play::Local::Library.import_song('/tmp/path')
    assert_equal 1, Play::Song.count
  end

  test "fs_songs" do
    FileUtils.mkdir_p '/tmp/play'
    FileUtils.touch '/tmp/play/song_1'
    FileUtils.touch '/tmp/play/song_2'
    assert_equal 2, Play::Local::Library.fs_songs('/tmp/play').size
  end
  
  test "enabled? should check for existence of afplay command" do
    lib = Play::Local::Library.new
    assert lib.enabled?
  end
  
  test "enabled? should check for existence of afplay command" do
    Play::Local::Library.any_instance.expects(:system).returns(false)
    lib = Play::Local::Library.new 
    assert !lib.enabled?
  end
  
  test "play! should call out to Mac system" do
    Play::Local::Library.any_instance.expects(:system).twice.returns(true)
    lib = Play::Local::Library.new
    song = Play::Song.create(:path => "/path/to/song")
    lib.play!(song)
  end
end
