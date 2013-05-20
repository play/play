require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "album page" do
    get :show, :artist_name => 'Justice', :name => 'Cross'

    assert_response :success
    assert response.body.include?('Cross')
  end

  test "album page handles escapes" do
    get :show, :artist_name => 'Jeff+Buckley', :name => 'Grace'

    assert_response :success
    assert response.body.include?('Grace')
  end

  test "album download" do
    get :download, :artist_name => 'Justice', :name => 'Cross'

    assert_response :success
    assert response.headers['Content-Disposition'].include?('Justice - Cross.zip')
  end
end
