require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "gets songs" do
    get :show, :name => 'Justice'

    assert_response :success
  end
end
