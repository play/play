//= require song

class Application extends Backbone.View
  el: $("main")

  initialize: ->
    this.updateNowPlaying()

  updateNowPlaying: ->
    $.ajax(
      dataType: 'json'
      url: '/now_playing',
      success: (response) ->
        $('#now-playing .name').html(response['name'])
        $('#now-playing .artist a').html(response['artist'])
        $('#now-playing .album a').html(response['album'])
    )

  window.Application = new Application