$ ->
  $('.controls .like').live 'click', (event) ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.post '/like',
      path: path
      (data) ->
        element.removeClass('icon-star-empty like')
        element.addClass('icon-star unlike')

  $('.controls .unlike').live 'click', (event) ->
    element = $(@)
    path = element.parents('.song').data('path')

    $.ajax '/like',
      type: 'PUT'
      data: { path: path }

    element.removeClass('icon-star unlike')
    element.addClass('icon-star-empty like')