class User < ActiveRecord::Base
  devise :token_authenticatable, :rememberable, :omniauthable, :omniauth_providers => [:github]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :remember_me, :provider, :uid
  validates_presence_of :login
  validates_uniqueness_of :login

  has_many :song_plays, :order => 'song_plays.created_at DESC'
  has_many :likes

  def self.find_for_github_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(:login    => auth.info.nickname,
                         :provider => auth.provider,
                         :uid      => auth.uid,
                         :email    => auth.info.email)
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["info"]["nickname"]
        user.email = data["email"] if user.email.blank?
      end
    end
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
end