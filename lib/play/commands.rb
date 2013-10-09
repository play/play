module Play
  module Commands

    def self.process_command(command, channel, user)
      begin
        result = Channels.process_command(command, channel, user)
        result = Controls.process_command(command, channel, user) unless result
        result = Information.process_command(command, channel, user) unless result
        result = Queueing.process_command(command, channel, user) unless result
        result = Speakers.process_command(command, channel, user) unless result

        result = Help.process_command(command, channel, user) unless result

        result || "#{command.inspect} doesn't even seem like a thing Play can do. Try /p help to brush up on the commands."
      rescue Exception
        "Heyoooo, something went wrong. Sorry, I couldn't process that."
      end
    end

    def self.queue_songs(channel, user, songs)
      songs.each{|song| channel.add(song, user)}
      "Queued up:\n" + songs.map {|song| %{"#{song.title}" by #{song.artist_name}} }.join("\n")
    end

    def self.queue_song(channel, user, song)
      channel.add song, user
      output = %{Queued up "#{song.title}" by #{song.artist_name}}
    end

    def self.find_speaker(speaker_name)
      speaker = Play.speakers.detect{|s| s.name == speaker_name}
      if speaker
        yield speaker
      else
        "Ooops, I don't know that speaker. These are the speakers I know: #{Play.speakers.map(&:name).join(', ')}"
      end
    end

  end
end
