class Api::CommandsController < Api::BaseController
  def create
    user = User.find_by_login(params[:login]) if params[:login].present?
    channel = Channel.find_by_name(params[:channel])

    if (params[:channel] && !channel)
      render :text => "Ooops, I don't know that channel. You're currently tuned to #{params[:channel]}. Maybe it's wrong?"
    else
      command = normalize_command(params[:command])
      output = execute(channel, user, command)

      render :text => output
    end
  end

  protected

  def normalize_command(command)
    (command || "")
      .strip                    # no leading/trailing spaces
      .gsub(/\s+/, " ")         # make sure all spaces, no newlines or tabs, and no doubles
      .gsub(/^(\/|hubot )/, '') # strip leading / or hubt
  end

  def execute(channel, user, command)
    case command
    when /^p(?:lay)?$/
      channel.mpd.play
      "You got it, playing"
    when /^(?:p(?:lay)? )?pause/i
      channel.mpd.pause = true
      "You got it, pausing"
    when /^(?:p(?:lay)? )?(sup|what'?s playing)\??$/i
      try_now_playing channel do |song|
        %{Now playing on #{channel.name}: "#{song.title}" by #{song.artist_name}, from "#{song.album_name}"}
      end
    when /^(?:p(?:lay)? )?next$/i
      try_next_song channel do |next_song|
        channel.mpd.next
        %{On to next one on #{channel.name}: "#{next_song.title}" by #{next_song.artist_name}, from "#{next_song.album_name}"}
      end
    when /^(?:p(?:lay)? )?(what's next\??|next\?)$/i
      try_next_song channel do |next_song|
        %{Up next on #{channel.name}: "#{next_song.title}" by #{next_song.artist_name}, from "#{next_song.album_name}"}
      end

    when /^(?:p(?:lay)? )?album (.*) by (.*)$/i
      album_name = $1
      artist_name = $2

      # FIXME this artist detection seems wonky, despite it being the same as in play by artist.
      # For example:
      # /play album yellow & green by baroness - doesn't work
      # /play album yellow & green by Baroness - does work
      # /play artist baroness - does work
      # /play artist Baroness - does work

      artist = Artist.new(:name => artist_name)
      album = artist.albums.select { |album| album.name.downcase == album_name.downcase }.first

      if album
        queue_songs(channel, user, album.songs)
      else
        %{Couldn't find album "#{album_name}" by #{artist_name} ;_;}
      end
    when /^(?:p(?:lay)? )?artist (.*)$/i
      artist_name = $1
      artist = Artist.new(:name => artist_name)

      songs = artist.songs.sample(3)

      if songs.any?
        queue_songs(channel, user, songs)
      else
        "Didn't find any songs by #{artist_name} ¯\_(ツ)_/¯"
      end
    when /^(?:p(?:lay)? )?(.*) by (.*)$/i
      song_name = $1
      artist_name = $2

      artist = Artist.new(:name => artist_name)
      song = artist.songs.find{|song| song.title.downcase == song_name.downcase}

      if song
        queue_song(channel, user, song)
      else
        %{Can't find "#{song_name}" by #{artist_name}}
      end
    when /^(?:p(?:lay)? )?I want this song$/i
      try_now_playing channel do |song|
        "Pretty rad, innit? Grab it for yourself: #{song_url(:artist_name => song.artist_name, :title => song.title)}"
      end
    when /^(?:p(?:lay)? )?I want this album$/i
      try_now_playing channel do |song|
        if song.album_name
          "dope beats available here: #{album_url(:artist_name => song.artist_name, :name => song.album_name)}"
        else
          %{"#{song.title}" by #{song.artist_name} isn't actually part of an album. Maybe you want just this song instead?}
        end
      end
    when /^(?:p(?:lay)? )?(something i('d)? like)|(the good shit)$/i
      songs = user.likes.limit(3).order('rand()').collect(&:song)

      queue_songs(channel, user, songs)
    when /^(?:p(?:lay)? )?I (like|star|love|dig) this( song)?$/i
      try_now_playing channel do |song|
        user.like(song.path)
        output = %{You like #{song.artist_name}'s "#{song.title}", too? Awesome.}
      end
    when /^(?:p(?:lay)? )?volume on (.*)$/i
      #  authedRequest message, "/speakers", 'get', {}, (err, res, body) ->
      #    json = JSON.parse(body)['speakers']
      #    speakers = json.filter (x) -> x['name'] == "play-#{speaker}"
      #    volume = speakers[0]['volume']
      #    message.send("Yo :#{message.message.user.name}:, the volume is #{volume} :mega:")
      "Still need to implement volume check (#{command.inspect}), lol"
    when /^(?:p(?:lay) )?volume (.*) (.*)$/i
      #  params = { speaker_name: speaker, level: volume }
      #  authedRequest message, "/speakers/#{speaker}/volume", 'post', params, (err, res, body) ->
      #    if msg=JSON.parse(body)['message']
      #      message.send(msg)
      #    else
      #      message.send("Bumped the volume to #{JSON.parse(body)['volume']}")
      "Still need to implement volume adjust (#{command.inspect}), lol"
    when /^(?:p(?:lay)? )?where'?s play$/i
      "#{channel.name} is at #{channel_url(channel)}, and can be streamed from #{api_channel_stream_url(channel)}"
    when /^(?:p(?:lay)? )?list channels$/i
      "These are the channels I know: #{Channel.all.map(&:name).join(', ')}"
    when /^(?:p(?:lay)? )?create channel (.*)$/i
      name = $1
      begin
        channel = Channel.create!(:name => name)
        "Ok, I created your channel! You can see it here: #{channel_url(channel)}. Or stream it from one of the great Play apps."
      rescue ActiveRecord::RecordInvalid
        channel = Channel.find_by_name(name)
        "Ooops! That channel already exist. You can see it here: #{channel_url(channel)}. Or stream it from one of the great Play apps."
      end
    when /^(?:play )?list speakers$/i
      "These are the speakers I know: #{Play.speakers.map(&:name).join(', ')}"
    when /^(?:play )?reset (.*)$/i
      try_speaker $1 do |speaker|
        speaker.reset
        "Ok, I reset the speaker for you."
      end
    else
      "lol wut? #{command.inspect} doesn't even seem like a thing Play can do"
    end
  end

  def queue_songs(channel, user, songs)
    songs.each{|song| channel.add(song, user)}

    "Queued up:\n" + songs.map {|song| %{"#{song.title}" by #{song.artist_name}} }.join("\n")
  end

  def queue_song(channel, user, song)
    channel.add song, user
    output = %{Queued up "#{song.title}" by #{song.artist_name}}
  end

  def try_now_playing(channel, queue_empty_message = nil )
    queue_empty_message ||= "The #{channel.name} queue is empty :( Try adding some songs, eh?"
    song = channel.now_playing

    if song
      yield song
    else
      queue_empty_message
    end

  end

  def try_next_song(channel)
    next_song = channel.queue[1]

    if next_song
      yield next_song
    else
      "The #{channel.name} queue is empty :( Try adding some songs, eh?"
    end

  end

  def try_speaker speaker_name
    speaker = Play.speakers.detect{|s| s.name == speaker_name}

    if speaker
      yield speaker
    else
      "Ooops, I don't know that speaker. These are the speakers I know: #{Play.speakers.map(&:name).join(', ')}"
    end

  end

end
