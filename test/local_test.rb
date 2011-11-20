require 'helper'

context "Local" do
  test "enabled? should check for existence of afplay command" do
    
    box = Play::Local::Jukebox.new
    assert box.enabled?
  end
  
  test "enabled? should check for existence of afplay command" do
    Play::Local::Jukebox.any_instance.expects(:system).returns(false)
    box = Play::Local::Jukebox.new 
    assert !box.enabled?
  end
  
  test "play! should call out to Mac system" do
    Play::Local::Jukebox.any_instance.expects(:system).twice.returns(true)
    box = Play::Local::Jukebox.new
    song = Play::Song.create(:path => "/path/to/song")
    box.play!(song)
  end
end
