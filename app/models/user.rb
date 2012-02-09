module Play

  # The User does things with Play. These are usually employees who try to
  # request songs to be played, but usually request crap like Garth Brooks.
  #
  # redis:
  #
  #   play:users                - A Set of all user IDs.
  #   play:users:#{login}:email - The String email for the given `login`.
  #   play:users:#{login}:stars - A Set of all Song `permanent_id`s that have
  #                               been starred by `login`.
  class User

    # The redis key to stash User data.
    KEY = 'play:users'

    # Public: The username of the user's GitHub account.
    attr_accessor :login

    # Public: The public email address listed on GitHub.
    attr_accessor :email

    # Public: Initializes a User.
    #
    # login - The String login of their GitHub account.
    # email - The String email address of their GitHub account.
    #
    # Returns the User.
    def initialize(login,email)
      @login = login.downcase
      @email = email
    end

    # Public: Create a User.
    #
    # login - The String login of their GitHub account.
    # email - The String email address of their GitHub account.
    #
    # Returns the User.
    def self.create(login,email)
      User.new(login,email).save
    end

    # Public: Finds a User.
    #
    # login - The String login.
    #
    # Returns the User, nil if no User found.
    def self.find(login)
      login.downcase!
      return nil if !$redis.sismember(KEY, login)
      email = $redis.get "#{KEY}:#{login}:email"

      User.new(login,email)
    end

    # Public: Saves the User.
    #
    # Returns itself.
    def save
      $redis.sadd KEY, login
      $redis.set  "#{KEY}:#{login}:email", email
      self
    end

    # Public: The MD5 hash of the user's email account. Used for showing their
    # Gravatar.
    #
    # Returns the String MD5 hash.
    def gravatar_id
      Digest::MD5.hexdigest(email) if email
    end

    # Public: A User's saved songs.
    #
    # Returns an Array of Songs.
    def stars
      stars = $redis.smembers("#{KEY}:#{login}:stars")
      stars.map do |id|
        Song.find(id)
      end
    end

    # Public: Did this user star this song?
    #
    # song - The Song.
    #
    # Returns a Boolean value.
    def starred?(song)
      $redis.smembers("#{KEY}:#{login}:stars").include?(song.id)
    end

    # Public: Stars a song. Likes a song. Saves a song.
    #
    # song - The Song to star.
    #
    # Returns true when saved.
    def star(song)
      $redis.sadd("#{KEY}:#{login}:stars",song.id)
      true
    end

    # Public: Removes a star.
    #
    # song - The Song to unstar.
    #
    # Returns true when saved.
    def unstar(song)
      $redis.srem("#{KEY}:#{login}:stars",song.id)
      true
    end

  end

end