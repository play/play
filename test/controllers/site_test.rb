require File.expand_path("../../helper", __FILE__)

context "Site" do
  setup do
  end

  test "index" do
    get "/"

    assert last_response.ok?
    assert last_response.body.include?('Play')
    assert last_response.body.include?('Search')
  end

  test "search" do
    get "/search", :q => 'Justice'

    assert last_response.ok?
    assert last_response.body.include?('Stress')
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

  test "add a song" do
    post "/queue", :path => 'Justice/Cross/Stress.mp3'

    assert last_response.ok?
    assert_equal 'added!', last_response.body
  end
end