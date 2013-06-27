require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "search" do
    get :search, :q => 'stress'

    assert_response :success
    assert response.body.include?('Stress')
  end

  test "search artist redirect" do
    get :search, :q => 'justice'

    assert_redirected_to artist_path('Justice')
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

  test "song upload" do
    path = 'test/music/Justice/Cross/Stress.mp3'
    file = ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join(path)),
      :filename => 'Stress.mp3'
    )
    post :create, :file => file

    assert_response 200
  end
end
