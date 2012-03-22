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


# A Speaker
class window.Speaker
  
  # Create new Speaker object.
  #
  # index - css id for the volume slider #speaker_index_volume
  # speaker - speaker JS object
  #   id   - String Speaker ID
  #   name - String Name the speaker uses.
  #   connected - Boolean speaker connected to airfoil audio source?
  #   volume - Float speaker volume 0.0 to 1.0.
  #
  # Returns new Speaker.
  constructor: (index, speaker) ->
    @css_id    = index
    @id        = speaker.id
    @name      = speaker.name
    @connected = speaker.connected
    @volume    = speaker.volume

  # Get the speaker connection icon. Returns the pink connected
  # speaker icon if connected and grey "disconnected" icon if 
  # disconnected. Obviously.
  #
  # Returns image tag with speaker icon.
  connection_tag: () ->
    if @connected
      image = "controller-speaker-on.svg"
    else
      image = "controller-speaker-off.svg"
    "<img class=\"toggle-connect\" src=\"images\/#{image}\" data-speaker-id=\"#{@id}\" data-speaker-connected=\"#{@connected}\" height=26 width=30 />"

  # Get the selector for the speaker's volume slider.
  #
  # Returns string slider css id.
  slider_selector: () ->
    "slider_#{@css_id}_volume"

  # Public - Toggle connection of a speaker.
  #
  # id - String speaker id.
  # connected - Boolean speaker connected?
  #
  # Returns nothing.
  @toggleConnection: (id, connected) ->
    if connected
      url = "/speaker/#{id}/disconnect"
    else
      url = "/speaker/#{id}/connect"
    $.ajax
      url: url,
      type: 'put',
      complete: () ->
        setTimeout renderSpeakers, 500
        return
    return

