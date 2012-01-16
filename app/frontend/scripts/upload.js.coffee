# Handles HTML5 File API jQuery Drag and Drop interface transmorgifier plugin
# stereotypical aphormational gimme the loot putting all the holes in the
# sweata biggie smalls.

$(document).ready () ->
  $('#fileupload').fileupload({
    dropZone: $('body'),
    dataType: 'json',
    sequentialUploads: true,
    url: '/upload'
  })

  updateProgress = (value) ->
    $('#progressbar').progressbar
      value: value

  $('#fileupload').bind 'fileuploadprogressall', (e, data) ->
    total = parseInt(data.loaded / data.total * 100, 10)
    updateProgress(total)

  $('#fileupload').bind 'fileuploadsend', (e, data) ->
    $('body').fadeTo(0,1)
    $('#uploads').slideDown(75)
    file = data.files[0].fileName
    $('#current').text(file)

  $('#fileupload').bind 'fileuploadstop', (e, data) ->
    $('#progressbar').slideUp(75)
    $('#uploads').hide()

  $('body').bind 'dragenter', (e) ->
    $('body').fadeTo(200,0.4)

  $('body').bind 'mouseout', (e) ->
    $('body').fadeTo(200,1)