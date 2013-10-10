module Play
  module Commands
    class Help

      def self.help
        items = []
        items << "### Help ###"
        items << "help - What you're looking at right now!"
      end

      def self.process_command(command, channel, user)
        case command
        when /help/i
          Play::Commands::Controls.help.join("\n") + ("\n\n") +
          Play::Commands::Queueing.help.join("\n") + ("\n\n") +
          Play::Commands::Information.help.join("\n") + ("\n\n") +
          Play::Commands::Channels.help.join("\n") + ("\n\n") +
          Play::Commands::Speakers.help.join("\n") + ("\n\n") +
          Play::Commands::Help.help.join("\n") + ("\n\n")
        end
      end

    end
  end
end
