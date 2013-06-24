$ ->
  zone = new Dropzone(document.body, {
    previewsContainer: ".upload-preview",
    clickable: false,
    url: "/songs"
  })

  zone.on "sending", (file, xhr) ->
    $('.upload-preview').show()
    $.rails.CSRFProtection(xhr)

  zone.on "totaluploadprogress", (progress, totalBytes, totalBytesSent) ->
    $('.dz-totalprogress .dz-upload').css('width', "#{progress}%")

  zone.on "processingfile", (file) ->
    $('.current-filename').text(file.name)

  zone.on "complete", () ->
    $('.current-filename').text('Done!')
    setTimeout ( ->
      $('.upload-preview').fadeOut(200)
    ), 2000

  zone.on "dragenter", (event) ->
    $('.drop-overlay').fadeIn(200)

  zone.on "dragleave", (e) ->
    rect = $('body')[0].getBoundingClientRect()

    # Fuck HTML5 drag and drop
    if (e.x > rect.left + rect.width || e.x < rect.left || e.y > rect.top + rect.height || e.y < rect.top)
      $('.drop-overlay').fadeOut(200)

  zone.on "drop", (event) ->
    $('.drop-overlay').fadeOut(200)
