# A single, solidatary Song.
class window.Song

  # Creates a new Song.
  #
  # id     - The String permanent_id of the iTunes track.
  # name   - The String name of the Song.
  # artist - The String name of the Artist.
  # album  - The String name of the Album.
  #
  # Returns a glorious Song.
  constructor: (@id, @name, @artist, @album) ->

  # The album art for this song.
  #
  # Returns a Sting HTML codez that renders this album art.
  art_tag: () ->
    "<img src=\"/images/art/#{@id}.png\" />"


# A listing of Songs.
#
# This is a simple Array of songs that serves to handle dealing with clumps of
# songs and rendering them on-page.
class window.List
  constructor: (@songs) ->