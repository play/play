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
