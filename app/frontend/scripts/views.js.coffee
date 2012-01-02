# A single, solidatary Song.
class window.Song
  constructor: (@name, @artist, @album) ->



# A listing of Songs.
#
# This is a simple Array of songs that serves to handle dealing with clumps of
# songs and rendering them on-page.
class window.List
  constructor: (@songs) ->