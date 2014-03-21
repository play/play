$ ->
  protocol = window.location.protocol
  hostname = window.location.hostname
  port     = 8000
  audio    = new Audio("#{protocol}//#{hostname}:#{port}")
  audio.play()

  $('.stream-controls').on 'click', (event) ->
    if audio.muted
      audio.muted = false
      $('.stream-controls').addClass("playing").removeClass("paused")
    else
      audio.muted = true
      $('.stream-controls').addClass("paused").removeClass("playing")
