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
  constructor: (json) ->
    @id      = json['id']
    @name    = json['name']
    @artist  = json['artist']
    @album   = json['album']
    @starred = json['starred']

  # The album art for this song.
  #
  # Returns a Sting HTML codez that renders this album art.
  art_tag: () ->
    "<img src=\"/images/art/#{@id}.png\" />"

  # Link to the Artist page.
  #
  # Uses hawt data-artist fields to populate the artist.
  artist_tag: () ->
    "<a href=\"#\" data-artist=\"#{@artist}\" class=\"artist\" >#{@artist}</a>"


# A listing of Songs.
#
# This is a simple Array of songs that serves to handle dealing with clumps of
# songs and rendering them on-page.
class window.List
  constructor: (@songs) ->