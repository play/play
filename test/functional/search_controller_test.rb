require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "index" do
    get :index

    assert_response :success
  end
end
