require 'helper'

context "Office" do
  setup do
  end

  test "url returns config office_url" do
    Play.expects(:config).returns({'office_url' => 'http://zachholman.com'})
    assert_equal 'http://zachholman.com', Play::Office.url
  end

  test "user string returns a string o' user data" do
    object = "lol"
    object.stubs(:read).returns("holman,kneath")
    Play::Office.stubs(:open).returns(object)
    assert_equal "holman,kneath", Play::Office.user_string
  end

  test "users are returned based on office string" do
    holman = Play::User.create(:office_string => 'holman')
    kneath = Play::User.create(:office_string => 'kneath')
    
    Play::Office.stubs(:user_string).returns("holman,defunkt")
    assert_equal [holman], Play::Office.users
  end
end
