//= require_directory ./frameworks
//= require_directory ./plugins

//= require views
//= require templates
//= require helpers

//= require realtime
//= require behaviors
//= require upload
//= require tv

play = exports ? this

# Automatically pull in Now Playing.
play.requestAndRenderNowPlaying()

# Automatically pull in your Queue.
play.renderQueue()