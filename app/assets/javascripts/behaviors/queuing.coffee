$ ->
  $('.controls .add').click ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.post '/add',
      path: path
      (data) ->
        element.text(data)