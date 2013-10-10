module Play
  module Commands
    class Speakers

      def self.help
        items = []
        items << "### Speakers ###"
        items << "list speakers - Shows a list of Play Speakers Play can currently see."
        items << "status for speaker <speaker> - Shows what the speaker is playing and it's volume."
        items << "set volume for speaker <speaker> to <level> - Sets the volume of the speaker. (0-100)."
        items << "tune speaker <speaker> to <channel> - Tunes the speaker to a specific channel."
        items << "reset speaker <speaker> - Resets the speaker. This will force it to restart playing."
      end

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
              speaker.tune(Rails.application.routes.url_helpers.api_channel_stream_url(channel, :host => Play.request_host))
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
