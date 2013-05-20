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

  test "user page with an invalid user" do
    get :show, :login => 'trolololol'

    assert_response :not_found
    assert response.body.include?("doesn't exist")
  end
end
