module Play
  module Commands
    class Channels

      def self.help
        items = []
        items << "### Channels ###"
        items << "list channels - List all of the available channels."
        items << "create channel <channel-name> - Create a Play channel."
      end

      def self.process_command(command, channel, user)
        case command
        when /list channels/i
          "These are the channels I know: #{Channel.all.map(&:name).join(', ')}"
        when /create channel (.*)/i
          name = $1
          begin
            channel = Channel.create!(:name => name)
            "Ok, I created your channel! You can browse it on Play or you can stream it from one of the great Play apps."
          rescue ActiveRecord::RecordInvalid
            channel = Channel.find_by_name(name)
            "Ooops! That channel already exist. You can browse it on Play or you can stream it from one of the great Play apps."
          end
        end
      end

    end
  end
end
