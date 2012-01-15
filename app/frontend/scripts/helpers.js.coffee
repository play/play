# Houses a bunch of functions that help us help you.

play = exports ? this

# Update the Songs listing with, you know, songs.
#
# Does that.
play.updateSongs = (path, method) ->
  $.ajax
    type: method,
    url: path,
    success: (response) ->
      list = listFromJson(JSON.parse(response))
      songs = Mustache.to_html(templates.list,list,templates)
      $('#songs').html(songs)

# Renders the "Now Playing" block off of JSON.
#
# Updates the #now-playing block with a Song.
play.renderNowPlaying = (json) ->
  song = songFromJson(json)
  rendered = Mustache.to_html(templates.now_playing,song,templates)
  $('#now-playing').html(rendered)

# Makes an ajax call and then sends the response over to render.
#
# This space intentionally filled with nonsense.
play.requestAndRenderNowPlaying = () ->
  $.ajax
    url: '/now_playing',
    dataType: 'json',
    success: (response) ->
      if response
        renderNowPlaying(response)

# Pushes out an ajax call and renders the damn queue.
#
# Returns like a boss.
play.renderQueue = () ->
  $.ajax
    url: '/queue',
    dataType: 'json',
    success: (response) ->
      song   = listFromJson(response)
      stache = Mustache.to_html(templates.list,song,templates)
      $('#songs').html(stache)

# Renders the star partial. It handles rendering whether something display "star
# this song" or "unstar this song".
#
# id      - The ID of the song.
# starred - The Boolean value of whether this should render as "star" or
#           "unstar".
play.renderStar = (id, starred) ->
  song = new Song({
    id: id
    starred: starred
  })
  Mustache.to_html(templates.star,song,templates)

# Takes a JSON response and parses it for our common Song attributes.
#
# json - The common JSON endpoint we return.
#
# Returns a Song.
play.songFromJson = (json) ->
  new Song(json)

# Create a List from a JSON-backed Array of Songs.
#
# json - The common JSON endpoint we return for multiple songs responses.
#
# Returns a List of Songs.
play.listFromJson = (json) ->
  songs = json.songs.map (song) ->
    songFromJson(song)
  new List(songs)