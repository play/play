# Behaviors are reactionary; this file details how to react when shit is clicked
# or submitted or prodded or poked or tebow'd.

play = exports ? this

$(document).ready () ->

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
    stream = $('#play-stream').get(0)
    if stream.paused
      stream.play()
    else
      stream.pause()
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

  # Pull in all the songs for a particular artist.
  #
  # data-artist - The Data attribute set on the link whose value is the
  #               artist name for this song.
  $('.artist').live 'click', () ->
    element = $(@)
    artist = escape(element.data('artist'))
    updateSongs("/artist/"+artist, "GET")
    false

  # Pull in all the songs for a particular artist.
  #
  # data-artist - The Data attribute set on the link whose value is the
  #               artist name for this song.
  $('.album').live 'click', () ->
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

  # Show the speaker list when the speaker icon is clicked.
  $('#speaker').live 'click', (e) ->
    e.preventDefault()
    renderSpeakers()
    return

  # Toggle a speakers connection to the Airfoil audio source.
  $('.toggle-connect').live 'click', (e) ->
    e.preventDefault()
    Speaker.toggleConnection $(this).data('speaker-id'), $(this).data('speaker-connected')
    return

  # Hide the speaker control panel when the mouse leaves the area.
  $('section.speakers').mouseleave () ->
    $(this).fadeOut()
    return
