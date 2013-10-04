module Play
  module Commands
    class Speakers

      def self.process_command(command, channel, user)
        case command
        when /list speakers/i
          "These are the speakers I know: #{Play.speakers.map(&:name).join(', ')}"
        when /status for speaker (.*)/i
          speaker_name = $1

          Play::Commands.find_speaker(speaker_name) do |speaker|
            status = speaker.status
            %{#{speaker.name} is currently playing: #{status['now_playing']} at a volume of #{status['volume']}%}
          end
        when /set volume for speaker (.*) to (\d\d)%?/i
          speaker_name = $1
          volume_level = $2

          Play::Commands.find_speaker(speaker_name) do |speaker|
            status = speaker.set_volume(volume_level)
            %{Ok, #{speaker_name} is now rocking it at #{volume_level}%}
          end
        when /tune speaker (.*) to (.*)/i
          speaker_name = $1

          Play::Commands.find_speaker(speaker_name) do |speaker|
            channel = Channel.find_by_name($2)
            if channel
              speaker.tune(api_channel_stream_url(channel))
              "Ok, I tuned that speaker to #{channel.name}"
            else
              "Hmm, I don't know that channel."
            end
          end
        when /reset speaker (.*)/i
          speaker_name = $1

          Play::Commands.find_speaker(speaker_name) do |speaker|
            speaker.reset
            "Ok, I reset the speaker for you."
          end
        end
      end


    end
  end
end
