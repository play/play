require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "search" do
    get :search, :q => 'Justice'

    assert_response :success
    assert response.body.include?('Stress')
  end

  test "song page" do
    get :show, :artist_name => 'Justice', :title => 'Stress'

    assert_response :success
    assert response.body.include?('Stress')
  end

  test "song download" do
    get :download, :path => "Justice/Cross/Stress.mp3"

    assert_response :success
    assert response.headers['Content-Disposition'].include?('Stress.mp3')
  end
end
