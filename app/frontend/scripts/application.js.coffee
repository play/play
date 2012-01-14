//= require mustache

//= require views
//= require templates

//= require realtime

play = exports ? this

$.ajax
  url: '/now_playing',
  dataType: 'json',
  success: (response) ->
    renderNowPlaying(response)

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

  # Searches things.
  $('#search').submit () ->
    keyword = $('#search').find('input')[0].value
    updateSongs("/search?q=#{keyword}", "GET")
    false

  # Clicking on a link with a class of `user` takes you to the user page.
  #
  # data-user - The Data attribute set on the link whose value is the username.
  $('.user').click () ->
    user = @text.substr(1)
    updateSongs("/user/#{user}","GET")
    false

  # Stars this song.
  #
  # data-song-id - The Data attribute set on the link whose value is the 
  #                persistent ID of the song.
  $('.star').live 'click', () ->
    id = $(@).data('song-id')
    $.ajax
      url: '/star',
      type: 'POST',
      data:
        id: id
      success: (response) ->
        alert response
    false

  # Unstars this song.
  #
  # data-song-id - The Data attribute set on the link whose value is the 
  #                persistent ID of the song.
  $('.unstar').live 'click', () ->
    id = $(@).data('song-id')
    $.ajax
      url: '/star',
      type: 'DELETE',
      data:
        id: id
      success: (response) ->
        alert response
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

# Takes a JSON response and parses it for our common Song attributes.
#
# json - The common JSON endpoint we return.
#
# Returns a Song.
songFromJson = (json) ->
  new Song(json.id, json.name, json.artist, json.album)

# Create a List from a JSON-backed Array of Songs.
#
# json - The common JSON endpoint we return for multiple songs responses.
#
# Returns a List of Songs.
listFromJson = (json) ->
  songs = json.songs.map (song) ->
    songFromJson(JSON.parse(song))
  new List(songs)