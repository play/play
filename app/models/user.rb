module Play

  # The User does things with Play. These are usually employees who try to
  # request songs to be played, but usually request crap like Garth Brooks.
  #
  # redis:
  #
  #   play:users                - A Set of all user IDs.
  #   play:users:#{login}:email - The String email for the given `login`.
  #   play:users:#{login}:token - The String token for the given `login`.
  #   play:users:#{login}:stars - A Set of all Song `permanent_id`s that have
  #                               been starred by `login`.
  #   play:users:#{token}:login - The String login for the given `token`.
  class User

    # The redis key to stash User data.
    KEY = 'play:users'

    # Public: The username of the user's GitHub account.
    attr_accessor :login

    # Public: The public email address listed on GitHub.
    attr_accessor :email

    # Public: The token used to auth with Play from a client.
    attr_accessor :token

    # Public: Initializes a User.
    #
    # login - The String login of their GitHub account.
    # email - The String email address of their GitHub account.
    # token - The String used to auth with Play from a client.
    #
    # Returns the User.
    def initialize(login,email,token=nil)
      @login = login.downcase
      @email = email
      @token = token
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
      token = $redis.get "#{KEY}:#{login}:token"

      User.new(login,email,token)
    end

    # Public: Finds a User by token.
    #
    # token - The String auth token.
    #
    # Returns the User, nil if no User found.
    def self.find_by_token(token)
      return nil if !login = $redis.get("#{KEY}:#{token}:login")
      self.find(login)
    end

    # Public: Saves the User.
    #
    # Returns itself.
    def save
      $redis.sadd KEY, login
      save_email
      save_token
      self
    end

    # Public: Saves the email.
    #
    # Returns bool.
    def save_email
      $redis.set  "#{KEY}:#{login}:email", email
    end

    # Public: Saves the token.
    #
    # Returns bool.
    def save_token
      self.token ||= Digest::MD5.hexdigest(login + Time.now.to_i.to_s)[0..5]
      $redis.set  "#{KEY}:#{login}:token", token
      $redis.set  "#{KEY}:#{token}:login", login
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