require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  test "loads an image" do
    get :art, :id => '123'

    assert_response :success
  end
end
