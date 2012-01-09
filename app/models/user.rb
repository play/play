module Play

  # The User does things with Play. These are usually employees who try to
  # request songs to be played, but usually request crap like Garth Brooks.
  class User

    # The redis key to stash User data.
    KEY = 'play:users'

    # The username of the user's GitHub account.
    attr_accessor :login

    # The public email address listed on GitHub.
    attr_accessor :email

    # Initializes a User.
    #
    # login - The String login of their GitHub account.
    # email - The String email address of their GitHub account.
    #
    # Returns the User.
    def initialize(login,email)
      @login = login
      @email = email
    end

    # Create a User.
    #
    # login - The String login of their GitHub account.
    # email - The String email address of their GitHub account.
    #
    # Returns the User.
    def self.create(login,email)
      User.new(login,email).save
    end

    # Finds a User.
    #
    # login - The String login.
    #
    # Returns the User, nil if no User found.
    def self.find(login)
      return nil if !$redis.sismember(KEY, login)
      email = $redis.get "#{KEY}:#{login}:email"

      User.new(login,email)
    end

    # Saves the User.
    #
    # Returns itself.
    def save
      $redis.sadd KEY, login
      $redis.set  "#{KEY}:#{login}:email", email
      self
    end

    # The MD5 hash of the user's email account. Used for showing their
    # Gravatar.
    #
    # Returns the String MD5 hash.
    def gravatar_id
      Digest::MD5.hexdigest(email) if email
    end

    def stars
      []
    end

  end

end