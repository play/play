class Api::CommandsController < Api::BaseController
  def create
    user = User.find_by_login(params[:login]) if params[:login].present?
    channel = Channel.find_by_name(params[:channel])

    command = (params[:command] || "")
                .strip                    # no leading/trailing spaces
                .gsub(/\s+/, " ")         # make sure all spaces, no newlines or tabs, and no doubles
                .gsub(/^(\/|hubot )/, '') # strip leading / or hubt

    case command
    when /^play$/
      channel.mpd.play
      output = "You got it, playing"
    when /^(?:play )?pause/i
      channel.mpd.pause = true
      output = "You got it, pausing"
    when /^(?:play )?(sup|what'?s playing)\??$/i
      song = channel.now_playing
      if song
        output = %{Now playing on #{channel.name}: "#{song.title}" by #{song.artist_name}, from "#{song.album_name}"}
      else
        output = "The queue is empty :( Try adding some songs, eh?"
      end
    when /^(?:play )?next$/i
      next_song = channel.queue[1]

      channel.mpd.next

      output = %{On to next one on #{channel.name}: "#{next_song.title}" by #{next_song.artist_name}, from "#{next_song.album_name}"}
    when /^(?:play )?(what's next\??|next\?)$/i
      next_song = channel.queue[1]

      if next_song
        output = %{Up next on #{channel.name}: "#{next_song.title}" by #{next_song.artist_name}, from "#{next_song.album_name}"}
      else
        output = "The queue is empty :( Try adding some songs, eh?"
      end
    when /^(?:play )?album (.*) by (.*)$/i
      album_name = $1
      artist_name = $2

      artist_name = channel.mpd.search(:artist, artist_name, :case_sensitive => false).first.try(:artist)
      artist = Artist.new(:name => artist_name)

      album = artist.albums.select { |album| album.name.downcase == album_name.downcase }.first
      songs = album.songs

      songs.each{|song| channel.add(song, user)}

      output = "Queued up:\n" + songs.map {|song| %{"#{song.title}" by #{song.artist_name}} }.join("\n")
    when /^(?:play )?artist (.*)$/i
      artist_name = $1

      artist = Artist.new(:name => artist_name)
      songs = artist.songs.sample(3)
      songs.each{|song| channel.add(song, user)}

      output = "Queued up:\n" + songs.map {|song| %{"#{song.title}" by #{song.artist_name}} }.join("\n")
    when /^(?:play )?(.*) by (.*)$/i
      song_name = $1
      artist_name = $2

      artist = Artist.new(:name => artist_name)

      if artist
        song = artist.songs.find{|song| song.title.downcase == song_name.downcase}
        if song
          channel.add song, user
          output = %{Queued up "#{song.title}" by #{song.artist_name}}
        else
          output = %{Can't find "#{song_name}" by #{artist_name}}
        end
      else
          output = %{Can't find artist #{artist_name}, let alone song "#{song_name}"}
      end
    when /^(?:play )?I want this song$/i
      song = channel.now_playing

      if song
        output = "Pretty rad, innit? Grab it for yourself: #{song_url(:artist_name => song.artist_name, :title => song.title)}"
      else
        output = "Nothing is playing on #{channel.name}, lol"
      end
    when /^(?:play )?I want this album$/i
      song = channel.now_playing

      if song
        output = "dope beats available here: #{album_url(:artist_name => song.artist_name, :name => song.album_name)}"
      else
        output = "Nothing is playing on #{channel.name}, lol"
      end
    when /^(?:play )?(something i('d)? like)|(the good shit)$/i
      songs = user.likes.limit(3).order('rand()').collect(&:song)
      songs.each do |song|
        channel.add(song,current_user)
      end

      output = "Queued up:\n" + songs.map {|song| %{"#{song.title}" by #{song.artist_name}} }.join("\n")
    when /^(?:play )?I (like|star|love|dig) this( song)?$/i 
      song = channel.now_playing

      if song
        user.like(song.path)
        output = %{You like #{song.artist_name}'s "#{song.title}", too? Awesome.}
      else
        output = %{You like the sound of silence, too? Awesome. Just kidding, why don't you play some music or something?}
      end
    when /^(?:play )?volume on (.*)$/i
      #  authedRequest message, "/speakers", 'get', {}, (err, res, body) ->
      #    json = JSON.parse(body)['speakers']
      #    speakers = json.filter (x) -> x['name'] == "play-#{speaker}"
      #    volume = speakers[0]['volume']
      #    message.send("Yo :#{message.message.user.name}:, the volume is #{volume} :mega:")
      output = "Still need to implement volume check (#{command.inspect}), lol"
    when /^(?:play )?volume (.*) (.*)$/i 
      #  params = { speaker_name: speaker, level: volume }
      #  authedRequest message, "/speakers/#{speaker}/volume", 'post', params, (err, res, body) ->
      #    if msg=JSON.parse(body)['message']
      #      message.send(msg)
      #    else
      #      message.send("Bumped the volume to #{JSON.parse(body)['volume']}")
      output = "Still need to implement volume adjust (#{command.inspect}), lol"
    when /^(?:play )?where'?s play$/i
      output = "#{channel.name} is at #{channel_url(channel)}, and can be streamed from #{api_channel_stream_url(channel)}"
    else
      output = "lol wut? #{command.inspect} doesn't even seem like a thing Play can do"
    end

    render :text => output
  end
end
