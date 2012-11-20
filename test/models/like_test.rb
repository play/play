require File.expand_path("../../helper", __FILE__)

context "Like" do
  setup do
  end

  test "doesn't let just any old value in here" do
    assert !Like.new(:song_path => 'wat', :user_id => 1, :value => 20).valid?
  end
end