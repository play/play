module Play
  # A buncha helpers we can include into things.
  module Helpers
    # Shortcut to the Client.
    #
    # Returns a Client.
    def client
      Client.new
    end
  end
end