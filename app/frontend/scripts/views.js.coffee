# A single, solidatary Song.
class window.Song

  # Creates a new Song.
  #
  # id      - The String permanent_id of the iTunes track.
  # name    - The String name of the Song.
  # artist  - The String name of the Artist.
  # album   - The String name of the Album.
  # starred - Did the user star this? A Boolean.
  # queued  - Is this queued up? A Boolean.
  #
  # Returns a glorious Song.
  constructor: (json) ->
    @id      = json['id']
    @name    = json['name']
    @artist  = json['artist']
    @album   = json['album']
    @starred = json['starred']
    @queued  = json['queued']

  # The album art for this song.
  #
  # Returns a Sting HTML codez that renders this album art.
  art_tag: () ->
    "<img src=\"/images/art/#{@id}.png\" />"

  # Link to the Artist page.
  #
  # Uses hawt data-artist fields to populate the artist.
  artist_tag: () ->
    "<a href=\"#\" data-artist=\"#{@artist}\" class=\"artist\">#{@artist}</a>"

  # Link to the Album page.
  #
  # Uses hawt data-artist and data-album fields to populate the artist.
  album_tag: () ->
    "<a href=\"#\" data-artist=\"#{@artist}\" data-album=\"#{@album}\" class=\"album\">#{@album}</a>"


# A listing of Songs.
#
# This is a simple Array of songs that serves to handle dealing with clumps of
# songs and rendering them on-page.
class window.List
  constructor: (@songs) ->