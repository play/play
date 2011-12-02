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
  
  test "fetches list of playlist keys" do
    rdio = Play::Rdio::Library.new
    rdio.fetch_playlists_keys
  end
  
  test "fetchtracks in playlist" do
    playlist_key = "p289885"
    rdio = Play::Rdio::Library.new
    puts rdio.fetch_playlist_tracks(playlist_key).inspect
  end
  
  test "sync tracks from library" do
    rdio = Play::Rdio::Library.new
    rdio.sync_tracks
  end

  test "launches web page" do
    rdio = Play::Rdio::Library.new
    
    puts rdio.launch_browser("t7349138")
    puts rdio.launch_browser("t7116197")
  end
=end

end