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
    from {{album}}
    and here's some art and shit: {{{art_tag}}}
    <a href="/star"   class="star"   data-song-id="{{id}}">star it</a>
    <a href="/unstar" class="unstar" data-song-id="{{id}}">unstar it</a>
  </div>
"""

templates.now_playing = """
  <ul>
    <li class="name">{{name}}</li>
    <li class="artist"><em>by</em> {{{artist_tag}}}</li>
    <li class="album"><em>from</em> <a href="#">{{album}}</a></li>
  </ul>

  <a class="album-art" href="#">{{{art_tag}}}</a>
"""