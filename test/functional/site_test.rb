require File.expand_path("../../helper", __FILE__)

context "Site" do
  setup do
  end

  test "index" do
    get "/"

    assert last_response.ok?
    assert last_response.body.include?('dat play')
  end

  test "artist page" do
    get "/artist/Justice"

    assert last_response.ok?
    assert last_response.body.include?('Cross')
  end
end