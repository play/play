module Play
  module Commands
    class Channels

      def self.process_command(command, channel, user)
        case command
        when /list channels/i
          "These are the channels I know: #{Channel.all.map(&:name).join(', ')}"
        when /create channel (.*)/i
          name = $1
          begin
            channel = Channel.create!(:name => name)
            "Ok, I created your channel! You can see it here: #{channel_url(channel)}. Or stream it from one of the great Play apps."
          rescue ActiveRecord::RecordInvalid
            channel = Channel.find_by_name(name)
            "Ooops! That channel already exist. You can see it here: #{channel_url(channel)}. Or stream it from one of the great Play apps."
          end
        end
      end

    end
  end
end
