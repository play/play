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
    Play::Office.stubs(:connection).returns(object)
    assert_equal "holman,kneath", Play::Office.user_string
  end

  test "users are returned based on office string or login" do
    holman = Play::User.create(:office_string => 'holman')
    kneath = Play::User.create(:office_string => 'kneath')
    trobrock = Play::User.create(:login => 'trobrock')
    neevor = Play::User.create(:login => 'neevor', :office_string => "neevor2")
    
    Play::Office.stubs(:user_string).returns("holman,defunkt,trobrock,neevor")
    assert_equal [holman,trobrock], Play::Office.users
  end
end
