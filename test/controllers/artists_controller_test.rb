require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "gets albums" do
    get :show, :artist_name => 'Justice'

    assert_response :success
    assert_equal 1, assigns(:albums).count
  end

  test "gets songs" do
    get :songs, :artist_name => 'Justice'

    assert_response :success
    assert_equal 1, assigns(:songs).count
  end
end
