$ ->
  $('.controls .like').click ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.post '/like',
      path: path
      (data) ->
        element.text('OK!')

  $('.controls .unlike').click ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.put '/like',
      path: path
      (data) ->
        element.text('OK!')

  $('.controls .dislike').click ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.delete '/like',
      path: path
      (data) ->
        element.text('OK!')