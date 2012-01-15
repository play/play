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
    {{name}}
    by {{{artist_tag}}}
    from {{{album_tag}}}

    {{{art_tag}}}

    {{>star}}
    {{>queuing}}
    {{>downloading}}
  </div>
"""

templates.now_playing = """
  <ul>
    <li class="name">{{name}}</li>
    <li class="artist"><em>by</em> {{{artist_tag}}}</li>
    <li class="album"><em>from</em> {{{album_tag}}}</li>
  </ul>

  <a class="album-art" href="#">{{{art_tag}}}</a>
"""

templates.star = """
  {{#starred}}
    <a href="/unstar" class="unstar" data-song-id="{{id}}">unstar it</a>
  {{/starred}}

  {{^starred}}
    <a href="/star" class="star" data-song-id="{{id}}">star it</a>
  {{/starred}}
"""

templates.queuing = """
  {{#queued}}
    <a href="/queue/remove" class="remove-from-queue" data-song-id="{{id}}">-</a>
  {{/queued}}

  {{^queued}}
    <a href="/queue/add" class="add-to-queue" data-song-id="{{id}}">+</a>
  {{/queued}}
"""

templates.downloading = """
  [download this album] [download this song]
"""