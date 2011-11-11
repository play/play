module Play
  class User < ActiveRecord::Base
    has_many :votes
    has_many :stars

    # Let the user vote for a particular song.
    #
    #   song - the Song that the user wants to vote up
    #
    # Returns the Vote object.
    def vote_for(song)
      votes.create(:song => song, :artist => song.artist)
    end
    
    # The count of the votes for this user. Used for Mustache purposes.
    #
    # Returns the Integer number of votes.
    def votes_count
      votes.count
    end

    # Queries the database for a user's favorite artists. It's culled just from
    # the historical votes of that user.
    #
    # Returns an Array of five Artist objects.
    def favorite_artists
      Artist.includes(:votes).
        where("votes.user_id = ?",id).
        group("votes.artist_id").
        order("count(votes.artist_id) desc").
        limit(5).
        all
    end

    # The MD5 hash of the user's email account. Used for showing their
    # Gravatar.
    #
    # Returns the String MD5 hash.
    def gravatar_id
      Digest::MD5.hexdigest(email) if email
    end

    # Authenticates a user. This will either select the existing user account,
    # or if it doesn't exist yet, create it on the system.
    #
    #   auth - the Hash representation returned by OmniAuth after
    #          authenticating
    #
    # Returns the User account.
    def self.authenticate(auth)
      if user = User.where(:login => auth['nickname']).first
        user
      else
        user = User.create(:login => auth['nickname'],
                           :name => auth['name'],
                           :email => auth['email'])
     end
    end
  end
end
