require File.expand_path("../../helper", __FILE__)

context "api/auth" do

  test "request without token" do
    unauthorized_get "/stream_url"
    # can't even test this yet because of the issue in boot.rb
    # assert_equal 401, last_response.status
  end

end
