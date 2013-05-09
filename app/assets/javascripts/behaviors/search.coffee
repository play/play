$ ->
  $('.advanced-search').live 'click', (event) ->
    if $('.filter').css('display') == 'inline'
      $('.filter').hide()
    else
      $('.filter').css('display', 'inline')

  $('.filter span').live 'click', (event) ->
    $('.filter span').removeClass('active')
    $(@).addClass('active')

    value = $(@).text().toLowerCase()
    value = 'title' if value == 'song'

    $('#filter').val(value)