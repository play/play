# Handles HTML5 File API jQuery Drag and Drop interface transmorgifier plugin
# stereotypical aphormational gimme the loot putting all the holes in the
# sweata biggie smalls.

$(document).ready () ->
  # Set up the file upload behavior on the invisa #fileupload box.
  $('#fileupload').fileupload({
    dropZone: $('body'),
    dataType: 'json',
    sequentialUploads: true,
    url: '/upload'
  })

  # Update the progress bar.
  updateProgress = (value) ->
    $('#progressbar').progressbar
      value: value

  # Get the overall progress of all uploads and display it.
  $('#fileupload').bind 'fileuploadprogressall', (e, data) ->
    total = parseInt(data.loaded / data.total * 100, 10)
    updateProgress(total)

  # Triggered after each file begins uploading to the server.
  $('#fileupload').bind 'fileuploadsend', (e, data) ->
    $('body').fadeTo(0,1)
    $('#uploads').slideDown(75)
    file = data.files[0].fileName
    $('#current').text(file)

  # Triggered after all uploads are finished.
  $('#fileupload').bind 'fileuploadstop', (e, data) ->
    $('#progressbar').slideUp(75)
    $('#uploads').hide()

  # Triggered when the mouse is dragging a file into the body. Fires randomly
  # while it's leaving and entering elements in <body>. Fuck HTML5 drag and drop
  # events. Fuck them.
  $('body').bind 'dragenter', (e) ->
    $('body').fadeTo(200,0.4)

  # If we drop some file, try to fade shit out. This is a hack. It's okay.
  $('body').bind 'drop', (e) ->
    $('body').fadeTo(200,1)

  # If the mouse leaves, try to fade shit out. This is a hack. It's okay.
  $('body').bind 'mouseout', (e) ->
    $('body').fadeTo(200,1)