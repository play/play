//= require mustache

//= require views
//= require templates
//= require helpers

//= require realtime
//= require behaviors

play = exports ? this

# Automatically pull in Now Playing.
play.requestAndRenderNowPlaying()

# Automatically pull in your Queue.
play.renderQueue()