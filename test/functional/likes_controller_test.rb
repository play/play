require 'test_helper'

class LikesControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "user page with likes" do
    @user.like('Justice/Cross/Stress.mp3')
    get :index, :login => @user.login

    assert_response :success
    assert response.body.include?('Stress')
  end

  test "likes a song" do
    post :create, :id => 'Justice/Cross/Stress.mp3'

    assert_equal 1, @user.likes.count
  end

  test "unlikes a song" do
    delete :destroy, :id => 'Justice/Cross/Stress.mp3'

    assert_equal 0, @user.likes.count
  end
end
