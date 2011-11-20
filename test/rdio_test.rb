require 'helper'

context "Local" do
  fixtures do
  end
=begin  
  test "should be enabled if we have the yml filled out" do
    assert Play::Rdio::Library.new.enabled?
  end
  
  test "fetches songs from library" do
    rdio = Play::Rdio::Library.new
    rdio.fetch_tracks(0).inspect
  end
  
  test "sync tracks from library" do
    rdio = Play::Rdio::Library.new
    rdio.sync_tracks
  end
=end
end