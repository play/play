class Api::CommandsController < Api::BaseController
  def create
    user = User.find_by_login(params[:login]) if params[:login].present?
    channel = Channel.find_by_name(params[:channel])

    command = (params[:command] || "")
                .strip            # no leading/trailing spaces
                .gsub(/\s+/, " ") # make sure all spaces, no newlines or tabs, and no doubles


    #TODO make sure to ^ and $ all these
    #TODO support optional 'play' prefix where it'd make sense
    case command
    when /^sup\??$/i
      song = channel.now_playing
      output = %{Now playing on #{channel.name}: "#{song.title}" by #{song.artist_name}, from "#{song.album_name}"}
    when /^next$/i
      next_song = channel.queue[1]

      channel.mpd.next

      output = %{On to next one on #{channel.name}: "#{next_song.title}" by #{next_song.artist_name}, from "#{next_song.album_name}"}
    when /^(what's next\??|next\?)$/i
      next_song = channel.queue[1]

      if next_song
        output = %{Up next on #{channel.name}: "#{next_song.title}" by #{next_song.artist_name}, from "#{next_song.album_name}"}
      else
        output = "The queue is empty :( Try adding some songs, eh?"
      end
    when /(.*) by (.*)/i
      #  if message.match[1].search(/artist/) != -1 ||
      #     message.match[1].search(/album/) != -1
      #    return

      #  params = { type: 'song', song_name: message.match[1], artist_name: message.match[2] }
      #  authedRequest message, '/queue/add', 'post', params, (err, res, body) ->
      #    if res.statusCode == 404
      #      return message.send("lol no idea what you're talking about")

      #    json = JSON.parse(body)
      #    song = json.songs[0]

      #    message.send("Queued up \"#{song.title}\" by #{song.artist_name}")
      
      output = "Still need to implement #{command.inspect}, lol"
    when /album (.*) by (.*)/i
      #  params = { type: 'album', album_name: message.match[1], artist_name: message.match[2] }
      #  authedRequest message, '/queue/add', 'post', params, (err, res, body) ->
      #    if res.statusCode == 404
      #      return message.send("lol no idea what you're talking about")

      #    json = JSON.parse(body)
      #    str  = json.songs.map (song) ->
      #      "\"#{song.title}\" by #{song.artist_name}"
      #    str.join(', ')

      #    message.send("Queued up #{str}")
      output = "Still need to implement #{command.inspect}, lol"
    when /artist (.*)/i
      #  params = { type: 'artist', artist_name: message.match[1] }
      #  authedRequest message, '/queue/add', 'post', params, (err, res, body) ->
      #    if res.statusCode == 404
      #      return message.send("lol no idea what you're talking about")

      #    json = JSON.parse(body)
      #    str  = json.songs.map (song) ->
      #      "\"#{song.title}\" by #{song.artist_name}"
      #    str.join(', ')

      #    message.send("Queued up #{str}")
      output = "Still need to implement #{command.inspect}, lol"
    when /I want this song/i
      #  authedRequest message, '/now_playing', 'get', {}, (err, res, body) ->
      #    json = JSON.parse(body)['now_playing']
      #    url  = "#{URL}/songs/download/#{escape json.path}"
      #    message.send("Pretty rad, innit? Grab it for yourself: #{url}")
      output = "Still need to implement #{command.inspect}, lol"
    when /I want this album/i
      #  authedRequest message, '/now_playing', 'get', {}, (err, res, body) ->
      #    json = JSON.parse(body)['now_playing']
      #    url  = "#{URL}/artists/#{escape json.artist_slug}/albums/#{escape json.album_slug}/download"
      #    message.send("dope beats available here: #{url}")
      output = "Still need to implement #{command.inspect}, lol"
    when /^(something i('d)? like)|(the good shit)$/i
      #  authedRequest message, '/queue/stars', 'post', {}, (err, res, body) ->
      #    json = JSON.parse(body)
      #    str = json.songs.map (song) ->
      #      "\"#{song.title}\" by #{song.artist_name}"
      #    str.join(', ')
      #    message.send("yo here's some songs: #{str}")
      output = "Still need to implement #{command.inspect}, lol"
    when /I (like|star|love|dig) this( song)?/i 
      #  authedRequest message, '/now_playing', 'post', {}, (err, res, body) ->
      #    json = JSON.parse(body)['now_playing']
      #    message.send("You like #{json.artist_name}'s \"#{json.title}\", too? Awesome.")
      output = "Still need to implement #{command.inspect}, lol"
    when /volume on (.*)/i
      #  authedRequest message, "/speakers", 'get', {}, (err, res, body) ->
      #    json = JSON.parse(body)['speakers']
      #    speakers = json.filter (x) -> x['name'] == "play-#{speaker}"
      #    volume = speakers[0]['volume']
      #    message.send("Yo :#{message.message.user.name}:, the volume is #{volume} :mega:")
      output = "Still need to implement #{command.inspect}, lol"
    when /volume (.*) (.*)/i 
      #  params = { speaker_name: speaker, level: volume }
      #  authedRequest message, "/speakers/#{speaker}/volume", 'post', params, (err, res, body) ->
      #    if msg=JSON.parse(body)['message']
      #      message.send(msg)
      #    else
      #      message.send("Bumped the volume to #{JSON.parse(body)['volume']}")
      output = "Still need to implement #{command.inspect}, lol"
    when /where'?s play/i
      #   authedRequest message, '/stream_url', 'get', {}, (err, res, body) ->
      #     message.send("play's at #{URL} and you can stream from #{body}")

      output = "Still need to implement #{command.inspect}, lol"
    else
      output = "lol wut? #{command.inspect}"
    end

    render :text => output
  end
end
