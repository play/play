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

  test "album page" do
    get "/artist/Justice/album/Cross"

    assert last_response.ok?
    assert last_response.body.include?('Stress')
  end

  test "song page" do
    get "/artist/Justice/song/Stress"

    assert last_response.ok?
    assert last_response.body.include?('Stress')
  end
end