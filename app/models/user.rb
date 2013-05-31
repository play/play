class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :remember_me, :provider, :uid
  validates_presence_of :login
  validates_uniqueness_of :login

  has_many :song_plays, :order => 'song_plays.created_at DESC'
  has_many :likes

  after_create :generate_token

  def self.find_for_github_oauth(auth)
    user = User.where(:login => auth.info.nickname).first
    unless user
      user = User.create(:login    => auth.info.nickname,
                         :email    => auth.info.email)
    end
    user
  end

  # The songs this user has requested.
  #
  # Returns an Array of Songs.
  def plays
    song_plays.map do |play|
      Song.new(play.song_path)
    end
  end

  # This user has played a song.
  #
  # Returns the new SongPlay.
  def play(song)
    SongPlay.new(:song_path => song.path, :user => self)
  end

  # Plays a song and saves it.
  #
  # Returns whether it was saved.
  def play!(song)
    play(song).save
  end

  # All of the liked Songs.
  #
  # Returns an Array of Songs.
  def liked_songs
    likes.map do |like|
      Song.new(like.song_path)
    end
  end

  # Does the current user like this song?
  #
  # Returns a Boolean.
  def likes?(song)
    likes.where(:song_path => song.path).any?
  end

  # Like a Song.
  #
  # Returns nothing.
  def like(path)
    unlike(path)

    like = likes.create(:song_path => path)
  end

  # Unlike a Song. Basically clear out anything we know about this user and
  # this song path.
  #
  # Returns nothing.
  def unlike(path)
    likes.where(:song_path => path).delete_all
  end

  # Public: The MD5 hash of the user's email account. Used for showing their
  # Gravatar.
  #
  # Returns the String MD5 hash.
  def gravatar_id
    Digest::MD5.hexdigest(email) if email
  end

  # Public: Generates and saves a new authentication token for this user.
  #
  # Returns nothing.
  def generate_token
    update_attribute(:token, Digest::MD5.hexdigest(login + Time.now.to_i.to_s + rand(999999).to_s)[0..4])
  end

end
