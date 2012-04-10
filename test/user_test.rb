require File.expand_path("../helper", __FILE__)

context "User" do

  setup do
    $redis.flushdb
    @user = User.create('holman','zach@example.com')
  end

  test "new" do
    user = User.new('jason','jason@example.com', '52df9')

    assert_equal 'jason', user.login
    assert_equal 'jason@example.com', user.email
    assert_equal '52df9', user.token
  end

  test "can't find a user" do
    assert User.find('a sane republican').nil?
  end

  test "totes can find a user" do
    user = User.find(@user.login)

    assert_equal @user.login, user.login
    assert_equal @user.email, user.email
  end

  test "gravatar_id" do
    assert_equal "fb8d9bbe8a1150bc9fed0b0f99bbfc47", @user.gravatar_id
  end

  test "has stars" do
    song = Song.new(:id => 'xyz')

    assert @user.stars.empty?

    Song.stubs(:find).with('xyz').returns(song)
    @user.star(song)

    assert_equal 1,     @user.stars.size
    assert_equal 'xyz', @user.stars.first.id
  end

  test "unstar" do
    song = Song.new(:id => 'xyz')
    Song.stubs(:find).with('xyz').returns(song)
    @user.star(song)

    assert !@user.stars.empty?

    @user.unstar(song)

    assert @user.stars.empty?
  end

end
