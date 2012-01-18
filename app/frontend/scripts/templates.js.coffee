# All of the client-side templates we use in Play. These are probably more
# "partials" than full-fledged templates, and from the perspective of
# mustache.js we use the two concepts interchangeably, as we define partials in
# the global `templates` Array.
window.templates = []

templates.list = """

  <div class="list">
    {{#songs}}
      {{>song}}
    {{/songs}}
  </div>
"""

templates.song = """
  <div class="song">
    <ul class="song-info">
      <li>{{name}}</li>
      <li>{{{artist_tag}}}</li>
      <!-- <li>{{{album_tag}}}</li> -->
    </ul>

    <ul class="song-actions">
      <li>{{>queuing}}</li>
      <li>{{>star}}</li>
      <li>{{>download_song}}</li>
    </ul>

    <div class="song_album">
      <a href="#" data-artist="{{{artist}}}" data-album="{{{album}}}" class="album album-art" alt="{{{album}}}">{{{art_tag}}}</a>
      {{>download_album}}
    </div>
  </div>
"""

templates.now_playing = """

  <div id="now-playing-actions">
  {{>star}}
  {{>download_song}}


  <ul>
    <li class="name">{{name}}</li>
    <li class="artist"><em>by</em> {{{artist_tag}}}</li>
    <li class="album"><em>from</em> {{{album_tag}}}</li>
  </ul>

  <a href="#" data-artist="{{{artist}}}" data-album="{{{album}}}" class="album album-art" alt="{{{album}}}">{{{art_tag}}}</a>
"""

templates.star = """
  {{#starred}}
    <a href="/unstar" class="unstar icon" data-song-id="{{id}}">unstar it</a>
  {{/starred}}

  {{^starred}}
    <a href="/star" class="star icon" data-song-id="{{id}}">star it</a>
  {{/starred}}
"""

templates.queuing = """
  {{#queued}}
    <a href="/queue/remove" class="remove-from-queue icon" data-song-id="{{id}}">-</a>
  {{/queued}}

  {{^queued}}
    <a href="/queue/add" class="add-to-queue icon" data-song-id="{{id}}">+</a>
  {{/queued}}
"""

templates.download_song = """
  <a class="dl-song icon" href="/song/{{id}}/download">download song</a>
"""

templates.download_album = """
  <a class="dl-song icon" href="/song/{{id}}/download">download album</a>
"""