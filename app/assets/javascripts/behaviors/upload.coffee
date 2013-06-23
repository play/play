$ ->
  zone = new Dropzone(document.body, {
    previewsContainer: ".upload-preview",
    clickable: false,
    url: "/songs"
  })

  zone.on "sending", (file, xhr) ->
    $.rails.CSRFProtection(xhr)
