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
    assert last_response.body.include?('Cross')
  end

  test "song page" do
    get "/artist/Justice/song/Stress"

    assert last_response.ok?
    assert last_response.body.include?('Stress')
  end

  test "song download" do
    get "/download/Justice/Cross/Stress.mp3"

    assert last_response.ok?
    assert last_response.headers['Content-Disposition'].include?('Stress.mp3')
  end

  test "album download" do
    get "/download/album/Justice/Cross/Stress.mp3"

    assert last_response.ok?
    assert last_response.headers['Content-Disposition'].include?('Justice - Cross.zip')
  end

  test "user page" do
    user = User.find_by_login('holman')
    get "/holman"

    assert last_response.ok?
    assert last_response.body.include?('holman')
  end

  test "user page with likes" do
    user = User.find_by_login('holman')
    user.like('Justice/Cross/Stress.mp3')
    get "/holman/likes"

    assert last_response.ok?
    assert last_response.body.include?('holman')
    assert last_response.body.include?('Stress')
  end

  test "user page with an invalid user" do
    get "/trolololol"

    assert_equal 404, last_response.status
    assert last_response.body.include?('Not found')
  end

  test "add a song" do
    post "/queue", :path => 'Justice/Cross/Stress.mp3'

    assert last_response.ok?
    assert_equal 'added!', last_response.body
  end

  test "add a song" do
    song = Song.new('Justice/Cross/Stress.mp3')
    user = User.new(:login => 'holman')

    Play::Queue.add(song,user)
    delete "/queue", :path => song.path

    assert last_response.ok?
    assert_equal 'deleted!', last_response.body
    assert_equal 0, Play::Queue.songs.size
  end

  test "likes a song" do
    post "/like", :path => 'Stress.mp3'
    user = User.where(:login => 'holman').first

    assert_equal 1, user.likes.count
    assert_equal 1, user.likes.last.value
  end

  test "unlikes a song" do
    put "/like", :path => 'Stress.mp3'
    user = User.where(:login => 'holman').first

    assert_equal 0, user.likes.count
  end
end