socket = new WebSocket('ws://localhost:3000/realtime')

socket.onopen = () ->
  alert 'open'
  console.log 'open'

socket.onmessage = (message) ->
  alert message
  console.log message
