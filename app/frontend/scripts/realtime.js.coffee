socket = new WebSocket('ws://localhost:3000/realtime')

socket.onopen = () ->
  console.log 'open'

socket.onmessage = (message) ->
  console.log message.data
