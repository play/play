# Behaviors are reactionary; this file details how to react when shit is clicked
# or submitted or prodded or poked or tebow'd.

play = exports ? this

$(document).ready () ->

  play.volume = 100
  play.volumeMin = 0
  play.volumeMax = 100
  play.playing = false
  
  $.get "/app-volume", (data) ->
    play.volume = Number data

  # Refreshes the Queue.
  $('.queue').click () ->
    play.renderQueue()
    false

  # Loads up the History.
  $('.history').click () ->
    updateSongs("/history", "GET")
    false

  # Plays the stream.
  $('#play').click () ->
    $.ajax
      type: "PUT"
      url: "/play"

  # Pauses music.
  $('#pause').click () ->
    updateSongs("/pause", "PUT")
    play.playing = false
    false

  # Goes back to the previous track.
  $('#previous').click () ->
    updateSongs("/previous", "PUT")
    false

  # Goes to the next track.
  $('#next').click () ->
    updateSongs("/next", "PUT")
    false
  
  volume = (units) ->
    units = units + play.volume
    units = Math.max(units, play.volumeMin)
    units = Math.min(units, play.volumeMax)
    $.ajax
      type: "PUT"
      data: {volume: units}
      url: "/app-volume"
      success: (data) ->
        play.volume = Number data
  
  $("#volume-up").click () ->
    volume +10
  
  $("#volume-down").click () ->
    volume -10

  # Pull in all the songs for a particular artist.
  #
  # data-artist - The Data attribute set on the link whose value is the
  #               artist name for this song.
  $(document).on 'click', '.artist', () ->
    element = $(@)
    artist = escape(element.data('artist'))
    updateSongs("/artist/"+artist, "GET")
    false

  # Pull in all the songs for a particular artist.
  #
  # data-artist - The Data attribute set on the link whose value is the
  #               artist name for this song.
  $(document).on 'click', '.album', () ->
    element = $(@)
    artist = escape(element.data('artist'))
    album  = escape(element.data('album'))
    updateSongs("/artist/"+artist+"/album/"+album, "GET")
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
  $('.user-logged-in a').click () ->
    user = @text.substr(1)
    updateSongs("/user/#{user}","GET")
    false

  # Stars this song.
  #
  # data-song-id - The Data attribute set on the link whose value is the
  #                persistent ID of the song.
  $('.star').live 'click', () ->
    play.spin(true)
    element = $(@)
    id = element.data('song-id')
    $.ajax
      url: '/star',
      type: 'POST',
      data:
        id: id
      success: (response) ->
        element.replaceWith(renderStar(id, true))
        play.spin(false)
    false

  # Unstars this song.
  #
  # data-song-id - The Data attribute set on the link whose value is the
  #                persistent ID of the song.
  $('.unstar').live 'click', () ->
    play.spin(true)
    element = $(@)
    id = element.data('song-id')
    $.ajax
      url: '/star',
      type: 'DELETE',
      data:
        id: id
      success: (response) ->
        element.replaceWith(renderStar(id, false))
        play.spin(false)
    false

  # Queues up this song.
  #
  # data-song-id - The Data attribute set on the link whose value is the
  #                persistent ID of the song.
  $(document).on 'click', '.add-to-queue', () ->
    play.spin(true)
    element = $(@)
    id = element.data('song-id')
    $.ajax
      url: '/queue',
      type: 'POST',
      data:
        id: id
      success: (response) ->
        element.replaceWith(queue(id, true))
        play.spin(false)
    false

  # Removes this song from the queue.
  #
  # data-song-id - The Data attribute set on the link whose value is the
  #                persistent ID of the song.
  $(document).on 'click', '.remove-from-queue', () ->
    play.spin(true)
    element = $(@)
    id = element.data('song-id')
    $.ajax
      url: '/queue',
      type: 'DELETE',
      data:
        id: id
      success: (response) ->
        element.replaceWith(queue(id, false))
        play.spin(false)
    false