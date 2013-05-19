require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "user page" do
    user = User.find_by_login('holman')
    get :show, :login => 'holman'

    assert_response :success
    assert response.body.include?('holman')
  end
end
