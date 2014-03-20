# Description:
#
#   Play music. At your office. Like a boss.
#   https://github.com/play/play
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_PLAY_URL
#   HUBOT_PLAY_TOKEN
#
# Commands:
#   hubot play - Plays music.
#   hubot play next - Plays the next song.
#   hubot play previous - Plays the previous song.
#   hubot what's playing - Returns the currently-played song.
#   hubot what's next - Returns next song in the queue.
#   hubot I want this song - Returns a download link for the current song.
#   hubot I want this album - Returns a download link for the current album.
#   hubot play artist <artist> - Queue up three songs from a given artist.
#   hubot play album <album> - Queue up an entire album.
#   hubot play <song> - Queue up a particular song. This grabs the first song by playcount.
#   hubot where's play - Gives you the URL to the web app.
#   hubot volume? - Returns the current volume level.
#   hubot volume [0-100] - Sets the volume.
#   hubot be quiet - Mute play.
#   hubot clear play - Clears the Play queue.
#
# Author:
#   holman

PLAY_URL   = "#{process.env.HUBOT_PLAY_URL}"
PLAY_TOKEN = "#{process.env.HUBOT_PLAY_TOKEN}"

SOUNDCLOUD_URL = /^https?:\/\/(www\.)?soundcloud\.com\/.+?\/.+/

authedRequest = (message, path, action, options, callback) ->
  message.http("#{PLAY_URL}/api#{path}")
    .query(login: message.message.user.githubLogin, token: "#{PLAY_TOKEN}")
    .header('Content-Length', 0)
    .query(options)[action]() (err, res, body) ->
      callback(err,res,body)

module.exports = (robot) ->
  # robot.respond /where'?s play/i, (message) ->
  #   message.finish()
  #   authedRequest message, '/stream_url', 'get', {}, (err, res, body) ->
  #     message.send("play's at #{PLAY_URL} and you can stream from #{body}")

  robot.respond /what'?s playing/i, (message) ->
    authedRequest message, '/now_playing', 'get', {}, (err, res, body) ->
      json = JSON.parse(body)['now_playing']
      str = "\"#{json.title}\" by #{json.artist_name}, from \"#{json.album_name}\"."
      message.send("#{PLAY_URL}#{json.album_art_path}")
      message.send("Now playing " + str)

  robot.respond /what'?s next/i, (message) ->
    authedRequest message, '/queue', 'get', {}, (err, res, body) ->
      json = JSON.parse(body)
      song = json.songs[1]
      if typeof(song) == "object"
        message.send("Next up: \"#{song.title}\" by #{song.artist_name}")
      else
        message.send("The queue is empty :( Try adding some songs, eh?")

  robot.respond /play next/i, (message) ->
    authedRequest message, '/next', 'post', {}, (err, res, body) ->
      json = JSON.parse(body)
      message.send("On to the next one.")


  #
  # VOLUME
  #

  robot.respond /volume on (.*)/i, (message) ->
    message.finish()
    speaker = message.match[1]
    authedRequest message, "/speakers", 'get', {}, (err, res, body) ->
      json = JSON.parse(body)['speakers']
      speakers = json.filter (x) -> x['name'] == "play-#{speaker}"
      volume = speakers[0]['volume']
      message.send("Yo :#{message.message.user.name}:, the volume is #{volume} :mega:")

  robot.respond /volume (.*) (.*)/i, (message) ->
    speaker = "play-#{message.match[1]}"
    volume  = message.match[2]

    params = { speaker_name: speaker, level: volume }
    authedRequest message, "/speakers/#{speaker}/volume", 'post', params, (err, res, body) ->
      if msg=JSON.parse(body)['message']
        message.send(msg)
      else
        message.send("Bumped the volume to #{JSON.parse(body)['volume']}")


  #
  # STARS
  #

  robot.respond /I want this song/i, (message) ->
    authedRequest message, '/now_playing', 'get', {}, (err, res, body) ->
      json = JSON.parse(body)['now_playing']
      url  = "#{PLAY_URL}/songs/download/#{escape json.path}"
      message.send("Pretty rad, innit? Grab it for yourself: #{url}")

  robot.respond /I want this album/i, (message) ->
    authedRequest message, '/now_playing', 'get', {}, (err, res, body) ->
      json = JSON.parse(body)['now_playing']
      url  = "#{PLAY_URL}/artists/#{escape json.artist_slug}/albums/#{escape json.album_slug}/download"
      message.send("dope beats available here: #{url}")

  robot.respond /(play something i('d)? like)|(play the good shit)/i, (message) ->
    message.finish()
    authedRequest message, '/queue/stars', 'post', {}, (err, res, body) ->
      json = JSON.parse(body)

      str = json.songs.map (song) ->
        "\"#{song.title}\" by #{song.artist_name}"
      str.join(', ')

      message.send("yo here's some songs: #{str}")

  robot.respond /I (like|star|love|dig) this( song)?/i, (message) ->
    authedRequest message, '/now_playing', 'post', {}, (err, res, body) ->
      json = JSON.parse(body)['now_playing']
      message.send("You like #{json.artist_name}'s \"#{json.title}\", too? Awesome.")

  #
  # PLAYING
  #

  robot.respond /play (.*) by (.*)/i, (message) ->
    if message.match[1].search(/artist/) != -1 ||
       message.match[1].search(/album/) != -1
      return

    params = { type: 'song', song_name: message.match[1], artist_name: message.match[2] }
    authedRequest message, '/queue/add', 'post', params, (err, res, body) ->
      if res.statusCode == 404
        return message.send("lol no idea what you're talking about")

      json = JSON.parse(body)
      song = json.songs[0]

      message.send("Queued up \"#{song.title}\" by #{song.artist_name}")

  robot.respond /play album (.*) by (.*)/i, (message) ->
    params = { type: 'album', album_name: message.match[1], artist_name: message.match[2] }
    authedRequest message, '/queue/add', 'post', params, (err, res, body) ->
      if res.statusCode == 404
        return message.send("lol no idea what you're talking about")

      json = JSON.parse(body)
      str  = json.songs.map (song) ->
        "\"#{song.title}\" by #{song.artist_name}"
      str.join(', ')

      message.send("Queued up #{str}")

  robot.respond /play artist (.*)/i, (message) ->
    params = { type: 'artist', artist_name: message.match[1] }
    authedRequest message, '/queue/add', 'post', params, (err, res, body) ->
      if res.statusCode == 404
        return message.send("lol no idea what you're talking about")

      json = JSON.parse(body)
      str  = json.songs.map (song) ->
        "\"#{song.title}\" by #{song.artist_name}"
      str.join(', ')

      message.send("Queued up #{str}")

  robot.respond /play soundcloud (.*)/i, (message) ->
    unless SOUNDCLOUD_URL.test message.match[1]
      return message.send("#{message.match[1]} doesn't look like a SoundCloud URL..")

    params = { type: 'soundcloud', url: message.match[1] }
    authedRequest message, '/queue/add', 'post', params, (err, res, body) ->
      if res.statusCode == 404
        return message.send(res.body)

      json = JSON.parse(body)

      message.send("Queued up #{message.match[1]}")
