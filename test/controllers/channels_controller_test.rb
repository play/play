require 'test_helper'

class ChannelsControllerTest < ActionController::TestCase
  setup do
    @channel = Channel.make!
    @user = User.make!
    sign_in @user
  end

  test "shows the queue" do
    # get :index
    #
    # assert_response :success
    # assert response.body.include?('Play')
    # assert response.body.include?('Search')
  end

  test "add a song" do
    @channel.clear
    post :add, :type => 'song', :id => 20, :song_id => 'Justice/Cross/Stress.mp3'

    assert_response :success
    assert_equal 'added!', response.body
    @channel.queue.include?(Song.make)
  end

  test "add an album" do
    @channel.clear
    post :add, :id => 20, :type => 'album', :artist => 'Justice', :name => 'Cross'

    assert_response :success
    assert_equal 'added!', response.body
  end

  test "delete a song" do
    @channel.clear
    song = Song.make
    user = User.make

    @channel.add(song,user)
    delete :remove, :id => 20, :song_id => song.path

    assert_response :success
    assert_equal 'deleted!', response.body
    assert_equal 0, @channel.queue.size
  end
end
