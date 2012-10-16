$ ->
  $('.controls .add').click ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.post '/queue',
      path: path
      (data) ->
        element.text(data)

  $('.controls .remove').click ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.ajax
      type: 'DELETE',
      url:  '/queue',
      data: {path: path},
      success: (data) ->
        element.text(data)