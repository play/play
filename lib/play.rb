require "play/api/error_delivery"
require "play/api/json_delivery"
require "play/api/api_response"
require "play/speaker"

module Play

  # Local instances of Play Speakers found on the network
  #
  # Returns an array of Speaker objects.
  def self.speakers
    @speakers ||= []
  end

end
