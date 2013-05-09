$ ->
  $('.controls .add').live 'click', (event) ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.post '/queue',
      path: path
      (data) ->
        element.addClass('icon-remove-sign remove')
        element.removeClass('icon-plus-sign-alt add')

  $('.controls .remove').live 'click', (event) ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.ajax
      type: 'DELETE',
      url:  '/queue',
      data: {path: path},
      success: (data) ->
        element.removeClass('icon-remove-sign remove')
        element.addClass('icon-plus-sign-alt add')