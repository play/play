Play.config['auth_token'] = '123456789'

def authorized_rack_env_for(user)
  {"HTTP_AUTHORIZATION" => user.token}
end

def authorized_get(uri, user, opts={})
  get uri, opts, authorized_rack_env_for(user)
end

def authorized_post(uri, user, opts={})
  post uri, opts, authorized_rack_env_for(user)
end

def authorized_put(uri, user, opts={})
  put uri, opts, authorized_rack_env_for(user)
end

def authorized_delete(uri, user, opts={})
  delete uri, opts, authorized_rack_env_for(user)
end

def unauthorized_get(uri, opts={})
  rack_env = {"HTTP_AUTHORIZATION" => "xxxxxxxxxxxxxxxxxx"}
  get uri, opts, rack_env
end

def assert_json(response)
  assert_equal 'application/json; charset=utf-8', response.headers["Content-Type"]
end

def parse_response(response)
  JSON::parse(response.body)
end

def assert_song_representation(object)
  keys = object.keys

  assert_equal 11, keys.size
  assert keys.include? 'title'
  assert keys.include? 'album_name'
  assert keys.include? 'album_slug'
  assert keys.include? 'artist_name'
  assert keys.include? 'artist_slug'
  assert keys.include? 'album_art_path'
  assert keys.include? 'seconds'
  assert keys.include? 'liked'
  assert keys.include? 'queued'
  assert keys.include? 'slug'
  assert keys.include? 'path'
end

def assert_album_representation(object)
  keys = object.keys

  assert_equal 6, keys.size
  assert keys.include? 'name'
  assert keys.include? 'artist_name'
  assert keys.include? 'artist_slug'
  assert keys.include? 'art_path'
  assert keys.include? 'slug'
  assert keys.include? 'songs'

  assert_equal Array, object['songs'].class

  assert_song_representation(object['songs'].first)
end

def assert_artist_representation(object)
  keys = object.keys

  assert_equal 2, keys.size
  assert keys.include? 'name'
  assert keys.include? 'slug'
end

def assert_user_representation(object)
  keys = object.keys

  assert_equal 2, keys.size
  assert keys.include? 'login'
  assert keys.include? 'slug'
end

def assert_speaker_representation(object)
  keys = object.keys

  assert_equal 5, keys.size
  assert keys.include? 'name'
  assert keys.include? 'host'
  assert keys.include? 'port'
  assert keys.include? 'volume'
  assert keys.include? 'slug'
end

def assert_channel_representation(object)
  keys = object.keys

  assert_equal 4, keys.size
  assert keys.include? 'name'
  assert keys.include? 'color'
  assert keys.include? 'now_playing'
  assert keys.include? 'slug'
end
