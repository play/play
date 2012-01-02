//= require mustache

//= require views
//= require templates

$.ajax
  url: '/now_playing',
  dataType: 'json',
  success: (response) ->
    song = new Song(response.name, response.artist)
    $('#now-playing').html(Mustache.to_html(templates.now_playing,song,templates))