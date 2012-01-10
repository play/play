require 'open-uri'

module Play
  class Office
    # The users currently present in the office.
    #
    # Returns an Array of User objects.
    def self.users
      string_cache = user_string
      return unless string_cache
      users = []
      string_cache.split(',').each do |string|
        users << User.find(string.downcase)
      end
      users.compact
    end

    # Opens up the office URL.
    #
    # Returns a String.
    def self.connection
      open(url)
    end

    # Hits the URL that we'll use to identify users.
    #
    # Returns a String of users (hopefully in comma-separated format).
    def self.user_string
      connection.read
    rescue Exception
      nil
    end

    # The URL we can check to come up with the list of users in the office.
    #
    # Returns the String configuration value for `office_url`.
    def self.url
      Play.config['office_url']
    end
  end
end
