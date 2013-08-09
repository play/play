require "play/api/error_delivery"
require "play/api/json_delivery"
require "play/api/api_response"

module Play

  # Local instances of Play Speakers found on the network
  #
  # Returns a hash of DNSSD objects keyed by their hostname.
  def self.speakers
    @speakers ||= {}
  end

end
