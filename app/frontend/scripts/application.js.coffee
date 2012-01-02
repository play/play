//= require mustache

//= require views
//= require templates

$.ajax
  url: '/now_playing',
  dataType: 'json',
  success: (response) ->
    song   = songFromJson(response)
    stache = Mustache.to_html(templates.now_playing,song,templates)
    $('#now-playing').html(stache)

$.ajax
  url: '/queue',
  dataType: 'json',
  success: (response) ->
    song   = listFromJson(response)
    stache = Mustache.to_html(templates.list,song,templates)
    $('#songs').html(stache)

# Takes a JSON response and parses it for our common Song attributes.
#
# json - The common JSON endpoint we return.
#
# Returns a Song.
songFromJson = (json) ->
  new Song(json.name, json.artist, json.album)

# Create a List from a JSON-backed Array of Songs.
#
# json - The common JSON endpoint we return for multiple songs responses.
#
# Returns a List of Songs.
listFromJson = (json) ->
  songs = json.songs.map (song) ->
    songFromJson(JSON.parse(song))
  new List(songs)