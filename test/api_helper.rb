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

def soundcloud_response
  <<-EOS
  {"kind":"track","id":47069209,"created_at":"2012/05/21 09:56:10 +0000","user_id":903649,"duration":242978,"commentable":true,"state":"finished","original_content_size":4858822,"sharing":"public","tag_list":"","permalink":"super-mario-bros-w-baseline","streamable":true,"embeddable_by":"all","downloadable":false,"purchase_url":null,"label_id":null,"purchase_title":null,"genre":"NIGGARACCI N SPANKY DPGC","title":"Super mario bros w baseline SNOOP PROD","description":"HIPPIE ERA ","label_name":"","release":"","track_type":"","key_signature":"","isrc":"","video_url":null,"bpm":null,"release_year":null,"release_month":null,"release_day":null,"original_format":"mp3","license":"all-rights-reserved","uri":"http://api.soundcloud.com/tracks/47069209","user":{"id":903649,"kind":"user","permalink":"snoopdogg","username":"Snoop Dogg","uri":"http://api.soundcloud.com/users/903649","permalink_url":"http://soundcloud.com/snoopdogg","avatar_url":"http://i1.sndcdn.com/avatars-000060899297-4nzb3m-large.jpg?435a760"},"permalink_url":"http://soundcloud.com/snoopdogg/super-mario-bros-w-baseline","artwork_url":null,"waveform_url":"http://w1.sndcdn.com/93pp93owvEnt_m.png","stream_url":"http://api.soundcloud.com/tracks/47069209/stream","playback_count":149692,"download_count":0,"favoritings_count":2361,"comment_count":306,"attachments_uri":"http://api.soundcloud.com/tracks/47069209/attachments"}
  EOS
end
