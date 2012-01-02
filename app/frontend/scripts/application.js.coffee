//= require ember

App = Ember.Application.create()

App.SongView = Ember.View.extend
  mouseDown: () ->
    window.alert "fuck ducks"