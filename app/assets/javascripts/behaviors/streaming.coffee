$ ->
  # Fuck these Safari crashes
  return false

  protocol = window.location.protocol
  hostname = window.location.hostname
  port     = 8000
  audio    = new Audio("#{protocol}//#{hostname}:#{port}")

  $('.stream-controls .icon-headphones').live 'click', (event) ->
    if audio.paused
      audio.play()
    else
      audio.pause()