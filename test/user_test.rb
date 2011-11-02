require 'helper'

context "User" do
  fixtures do
    @user = Play::User.create(:email => "holman@example.com")
  end

  test "vote for" do
    @user.vote_for(Play::Song.create)
    assert_equal 1, @user.votes.count
  end

  test "gravatar_id" do
    assert_equal "54e4ab9ced3fd1f3f5b20ab2f8201b73", @user.gravatar_id
  end

  test "votes count" do
    @user.vote_for(Play::Song.create)
    assert_equal 1, @user.votes_count
  end
end
