require File.expand_path("../helper", __FILE__)

context "User" do

  setup do
    $redis.flushdb
    @user = User.create('holman','zach@example.com')
  end

  test "new" do
    user = User.new('jason','jason@example.com')

    assert_equal 'jason', user.login
    assert_equal 'jason@example.com', user.email
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

end
