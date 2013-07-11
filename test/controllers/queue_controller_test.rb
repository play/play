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

  test "add a song" do
    PlayQueue.clear
    post :create, :type => 'song', :id => 'Justice/Cross/Stress.mp3'

    assert_response :success
    assert_equal 'added!', response.body
    PlayQueue.songs.include?(Song.make)
  end

  test "add an album" do
    PlayQueue.clear
    post :create, :type => 'album', :artist => 'Justice', :name => 'Cross'

    assert_response :success
    assert_equal 'added!', response.body
    PlayQueue.songs.include?(Song.make)
  end

  test "delete a song" do
    PlayQueue.clear
    song = Song.make
    user = User.make

    PlayQueue.add(song,user)
    delete :destroy, :id => song.path

    assert_response :success
    assert_equal 'deleted!', response.body
    assert_equal 0, PlayQueue.songs.size
  end
end
