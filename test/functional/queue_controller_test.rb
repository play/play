require 'test_helper'

class QueueControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "shows the queue" do
    get :index

    assert_response :success
    assert response.body.include?('Play')
    assert response.body.include?('Search')
  end
end
