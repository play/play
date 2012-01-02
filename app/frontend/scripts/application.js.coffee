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

# Takes a JSON response and parses it for our common Song attributes.
#
# json - The common JSON endpoint we return.
#
# Returns a Song.
songFromJson = (json) ->
  new Song(json.name, json.artist, json.album)