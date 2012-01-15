//= require mustache

//= require views
//= require templates
//= require helpers

//= require realtime

play = exports ? this

# Automatically pull in Now Playing.
play.requestAndRenderNowPlaying()

# Automatically pull in your Queue.
play.renderQueue()

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
  $('.user-logged-in').click () ->
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

  # Queues up this song.
  #
  # data-song-id - The Data attribute set on the link whose value is the 
  #                persistent ID of the song.
  $('.add-to-queue').live 'click', () ->
    element = $(@)
    id = element.data('song-id')
    $.ajax
      url: '/queue',
      type: 'POST',
      data:
        id: id
      success: (response) ->
        alert 'added!'
    false

  # Removes this song from the queue.
  #
  # data-song-id - The Data attribute set on the link whose value is the 
  #                persistent ID of the song.
  $('.remove-from-queue').live 'click', () ->
    element = $(@)
    id = element.data('song-id')
    $.ajax
      url: '/queue',
      type: 'DELETE',
      data:
        id: id
      success: (response) ->
        alert 'removed!'
    false