require File.expand_path("../helper", __FILE__)

context "Play" do

  test "config" do
    yaml = {
      'gh_secret' => "sekrets",
      'gh_key'    => "clientz"
    }
    Play.stubs(:yaml).returns(yaml)

    assert_equal "sekrets", Play.config.secret
    assert_equal "clientz", Play.config.client_id
  end

end
