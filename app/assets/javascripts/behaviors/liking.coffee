$ ->
  $('.track .like, .song .like').live 'click', (event) ->
    element = $(@)
    path = element.parents('.song, .track').data('path')

    $.post '/like',
      path: path
      (data) ->
        element.removeClass('icon-star-empty like')
        element.addClass('icon-star unlike')

  $('.track .unlike, .song .unlike').live 'click', (event) ->
    element = $(@)
    path = element.parents('.song, .track').data('path')

    $.ajax '/like',
      type: 'PUT'
      data: { path: path }

    element.removeClass('icon-star unlike')
    element.addClass('icon-star-empty like')

  # Now playing likes/unlikes
  $('.now-playing-actions li').live 'click', (event) ->
    element = $(@)
    span    = element.find('span')
    path    = element.parent().data('path')

    if span.hasClass('like')
      $.post '/like',
        path: path
        (data) ->
          span.removeClass('icon-star-empty like')
          span.addClass('icon-star unlike')

          login = $('body').data('login')
          gravatar_id = $('body').data('gravatar-id')
          $(".fans ul").append("<li class=\"fan\" data-login=\"#{login}\"><a href=\"/#{login}\">
              <img src=\"http://www.gravatar.com/avatar/#{gravatar_id}?s=50\" />
            </a></li>")
    else
      $.ajax '/like',
        type: 'PUT'
        data: { path: path }

        span.addClass('icon-star-empty like')
        span.removeClass('icon-star unlike')

        login = $('body').data('login')
        $(".fan[data-login=#{login}]").remove()