require File.expand_path("../../helper", __FILE__)

context "User" do
  setup do
    @user = User.new(:login => 'holman', :email => 'holman@example.com')
  end

  test "has attributes" do
    assert_equal 'holman', @user.login
    assert_equal 'holman@example.com', @user.email
  end
end