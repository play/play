$ ->
  # Fuck these Safari crashes
  return false

  protocol = window.location.protocol
  hostname = window.location.hostname
  port     = 8000
  audio    = new Audio("#{protocol}//#{hostname}:#{port}")

  $('.stream-controls').on 'click', (event) ->
    if audio.paused
      audio.play()
      $('.stream-controls').addClass("playing").removeClass("paused")
    else
      audio.pause()
      $('.stream-controls').addClass("paused").removeClass("playing")
