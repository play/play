$ ->
  $('.controls .add').click ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.post '/queue',
      path: path
      (data) ->
        element.text(data)

    $.delete '/queue',
      path: path
      (data) ->
        element.text(data)