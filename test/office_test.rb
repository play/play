require File.expand_path("../helper", __FILE__)

context "Office" do
  setup do
  end

  test "user string returns a string o' user data" do
    object = "lol"
    object.stubs(:read).returns("holman,kneath")
    Office.stubs(:connection).returns(object)
    assert_equal "holman,kneath", Office.user_string
  end

  test "users are returned based on office string" do
    holman = User.create 'holman', 'zach@example.com'
    kneath = User.create 'kneath', 'kyle@example.com'

    Office.stubs(:user_string).returns("holman,defunkt")
    assert_equal ['holman'], Office.users.map{|user| user.login}
  end
end
