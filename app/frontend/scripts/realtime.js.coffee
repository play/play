play = exports ? this

socket = new WebSocket('ws://localhost:5050/realtime')

socket.onopen = () ->

socket.onmessage = (message) ->
  song = JSON.parse(message.data).now_playing
  play.renderNowPlaying(JSON.parse(song))
