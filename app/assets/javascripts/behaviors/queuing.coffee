$ ->
  $('.track .add, .song .add').live 'click', (event) ->
    element = $(@)
    path = element.parents('.song, .track').data('path')

    $.ajax
      type: 'post',
      url:  '/queue',
      data: { type: 'song', id: path },
      success: (data) ->
        element.addClass('icon-remove-sign remove')
        element.removeClass('icon-plus-sign-alt add')

  $('.track .remove, .song .remove').live 'click', (event) ->
    element = $(@)
    path = element.parents('.song, .track').data('path')

    $.ajax
      type: 'delete',
      url:  '/queue',
      data: { id: path },
      success: (data) ->
        element.removeClass('icon-remove-sign remove')
        element.addClass('icon-plus-sign-alt add')

  $('.album .add').live 'click', (event) ->
    element = $(@)
    icon = element.children('.icon')
    message = element.children('.message')
    artist = element.parents('.album').data('artist')
    name = element.parents('.album').data('name')
    message.parent('li').css('background-color: #d830e2')

    message.text('Queuing...')
    icon.removeClass('icon-plus-sign-alt').addClass('icon-spinner').addClass('icon-spin')

    $.ajax
      type: 'post',
      url:  '/queue',
      data: { type: 'album', artist: artist, name: name },
      success: (data) ->
        message.text('Good pick!')
        icon.removeClass('icon-spinner').removeClass('icon-spin').addClass('icon-check-sign')
        $('.track .icon-plus-sign-alt.add, .song .icon-plus-sign-alt.add').removeClass('icon-plus-sign-alt add').addClass('icon-remove-sign remove')
      error: (xhr, ajaxOptions, thrownError) ->
        message.text('Failed :(')
        icon.removeClass('icon-spinner').removeClass('icon-spin').addClass('icon-exclamation-sign')

    return false
