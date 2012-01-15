//= require mustache

//= require views
//= require templates

//= require realtime

play = exports ? this

# Automatically pull in Now Playing.
$.ajax
  url: '/now_playing',
  dataType: 'json',
  success: (response) ->
    renderNowPlaying(response)

# Automatically pull in your Queue.
$.ajax
  url: '/queue',
  dataType: 'json',
  success: (response) ->
    song   = listFromJson(response)
    stache = Mustache.to_html(templates.list,song,templates)
    $('#songs').html(stache)

$(document).ready () ->

  # Plays music.
  $('#play').click () ->
    updateSongs("/play", "PUT")
    false
  
  # Pauses music.
  $('#pause').click () ->
    updateSongs("/pause", "PUT")
    false

  # Goes back to the previous track.
  $('#previous').click () ->
    updateSongs("/previous", "PUT")
    false

  # Goes to the next track.
  $('#next').click () ->
    updateSongs("/next", "PUT")
    false

  # Clear out search copy on click.
  $('#search input').click () ->
    $(@).val('')

  # Searches things.
  $('#search').submit () ->
    keyword = $('#search').find('input')[0].value
    updateSongs("/search?q=#{keyword}", "GET")
    false

  # Clicking on a link with a class of `user` takes you to the user page.
  #
  # Assumes the anchor text is `@login`, which then gets its `@` stripped.
  $('.user').click () ->
    user = @text.substr(1)
    updateSongs("/user/#{user}","GET")
    false

  # Stars this song.
  #
  # data-song-id - The Data attribute set on the link whose value is the 
  #                persistent ID of the song.
  $('.star').live 'click', () ->
    element = $(@)
    id = element.data('song-id')
    $.ajax
      url: '/star',
      type: 'POST',
      data:
        id: id
      success: (response) ->
        element.replaceWith(renderStar(id, true))
    false

  # Unstars this song.
  #
  # data-song-id - The Data attribute set on the link whose value is the 
  #                persistent ID of the song.
  $('.unstar').live 'click', () ->
    element = $(@)
    id = element.data('song-id')
    $.ajax
      url: '/star',
      type: 'DELETE',
      data:
        id: id
      success: (response) ->
        element.replaceWith(renderStar(id, false))
    false

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
songFromJson = (json) ->
  new Song(json)

# Create a List from a JSON-backed Array of Songs.
#
# json - The common JSON endpoint we return for multiple songs responses.
#
# Returns a List of Songs.
listFromJson = (json) ->
  songs = json.songs.map (song) ->
    songFromJson(song)
  new List(songs)