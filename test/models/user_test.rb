require File.expand_path("../../helper", __FILE__)

context "User" do
  setup do
    @user = User.find_by_login('holman')
    @user.likes.delete_all
  end

  test "has attributes" do
    assert_equal 'holman', @user.login
  end

  test "has plays" do
    assert @user.plays.present?
  end

  test "plays a song" do
    @user.play!(Song.new('Justice'))
    assert !@user.plays.empty?
  end

  test "liked songs" do
    @user.like('Justice/Cross/Stress.mp3')

    assert @user.liked_songs.is_a?(Array)
    assert @user.liked_songs.first.is_a?(Song)
  end

  test "can like a song" do
    @user.like('any/song.mp3')

    assert_equal 1, @user.likes.count
  end

  test "clears likes" do
    @user.like('any/song.mp3')
    assert_equal 1, @user.likes.count

    @user.unlike('any/song.mp3')
    assert_equal 0, @user.likes.count
  end

  test "likes a particular song" do
    song = Song.new('Justice/song')
    @user.like(song.path)
    assert @user.likes?(song)

    song = Song.new('Justice/nope-song')
    assert !@user.likes?(song)
  end
end