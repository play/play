# Handles HTML5 File API jQuery Drag and Drop interface transmorgifier plugin
# stereotypical aphormational gimme the loot putting all the holes in the
# sweata biggie smalls.

$(document).ready () ->
  $('#fileupload').fileupload({
    dropZone: $('body'),
    dataType: 'json',
    url: '/upload',
    done: (e, data) ->
      alert 'wat'  
  })

  $('body').bind 'dragenter', (e) ->
    $('body').fadeTo(200,0.4)

  $('body').bind 'mouseout', (e) ->
    $('body').fadeTo(200,1)