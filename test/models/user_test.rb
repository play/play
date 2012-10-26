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

  test "likes a song" do
    @user.like('any/song.mp3')

    assert_equal 1, @user.likes.last.value
  end

  test "clears likes" do
    @user.like('any/song.mp3')
    assert_equal 1, @user.likes.count

    @user.unlike('any/song.mp3')
    assert_equal 0, @user.likes.count
  end

  test "dislikes a song" do
    @user.dislike('any/song.mp3')

    assert_equal 1, @user.likes.count
    assert_equal -1, @user.likes.first.value
  end
end