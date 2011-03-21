require 'helper'

context "Song" do
  fixtures do
    @song = Play::Song.create
    @user = Play::User.create
  end

  test "artist_name" do
    @song.artist = Play::Artist.new(:name => "Justice")
    assert_equal "Justice", @song.artist_name
  end

  test "album_name" do
    @song.album = Play::Album.new(:name => "A Cross the Universe")
    assert_equal "A Cross the Universe", @song.album_name
  end

  test "enqueue queues it up" do
    @song.enqueue! @user
    assert @song.queued
  end

  test "enqueue adds a user vote" do
    @song.enqueue! @user
    assert_equal 1, Play::Vote.count
  end

  test "dequeue" do
    @song.dequeue! @user
    assert !@song.queued
  end

  test "plays" do
    assert_equal 0, Play::Song.where(:now_playing => true).count
    @song.play!
    assert_equal 1, Play::Song.where(:now_playing => true).count
  end

  test "play next in queue adds a new history" do
    @song.update_attribute(:queued, true)
    Play::Song.play_next_in_queue
    assert_equal 1, Play::History.count
  end

  test "play next in queue sets the song as playing" do
    @song.update_attribute(:queued, true)
    Play::Song.play_next_in_queue
    @song.reload
    assert @song.now_playing?
  end

  test "play next in queue dequeues the song" do
    @song.update_attribute(:queued, true)
    Play::Song.play_next_in_queue
    @song.reload
    assert !@song.queued?
  end

  test "play next in queue returns the song" do
    @song.update_attribute(:queued, true)
    assert_equal @song, Play::Song.play_next_in_queue
  end

  test "generates a song for the office" do
    @artist1 = Play::Artist.create
    @song1   = Play::Song.create(:artist => @artist1)
    @artist2 = Play::Artist.create
    @song2   = Play::Song.create(:artist => @artist2)
    @user    = Play::User.create

    users = [@user]
    @user.stubs(:favorite_artists).returns([@artist1])
    Play::Office.expects(:users).returns(users)
    assert_equal @song1, Play::Song.office_song
  end

end
