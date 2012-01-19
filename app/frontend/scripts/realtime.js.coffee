play = exports ? this

socket = new WebSocket('ws://localhost:9393/realtime')

socket.onopen = () ->

socket.onmessage = (message) ->
  song = JSON.parse(message.data).now_playing

  if song
    play.renderNowPlaying(song)

  list = listFromJson(JSON.parse(message.data))
  songs = Mustache.to_html(templates.list,list,templates)
  $('#songs').html(songs)