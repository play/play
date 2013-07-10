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
  Yajl::load(response.body)
end

def assert_song_representation(object)
  keys = object.keys

  assert_equal 4, keys.size
  assert keys.include? 'title'
  assert keys.include? 'album'
  assert keys.include? 'seconds'
  assert keys.include? 'slug'

  assert_album_representation object['album']
end

def assert_album_representation(object)
  keys = object.keys

  assert_equal 3, keys.size
  assert keys.include? 'name'
  assert keys.include? 'artist'
  assert keys.include? 'slug'

  assert_artist_representation object['artist']
end

def assert_artist_representation(object)
  keys = object.keys

  assert_equal 2, keys.size
  assert keys.include? 'name'
  assert keys.include? 'slug'
end
