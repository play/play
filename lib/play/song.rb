module Play
  class Song < ActiveRecord::Base
    belongs_to :artist
    belongs_to :album
    has_many :votes
    has_many :histories

    scope :queue, select("songs.*,(select count(song_id) from votes where song_id=songs.id and active=1) as song_count").
                  where(:queued => true).
                  order("song_count desc, updated_at")

    # The name of the artist. Used for Mustache purposes.
    #
    # Returns the String name of the artist.
    def artist_name
      artist.name
    end

    # The name of the album. Used for Mustache purposes.
    #
    # Returns the String name of the album.
    def album_name
      album.name
    end

    # The current votes for a song. A song may have many historical votes,
    # which is well and good, but here we're only concerned for the current
    # round of whether it's voted for.
    #
    # Returns and Array of Vote objects.
    def current_votes
      votes.where(:active => true).all
    end

    # Queue up a song.
    #
    #   user - the User who is requesting the song to be queued
    #
    # Returns the result of the user's vote for that song.
    def enqueue!(user)
      self.queued = true
      save
      user.vote_for(self)
    end

    # Remove a song from the queue
    #
    #   user - the User who is requesting the song be removed
    #
    # Returns true if removed properly, false otherwise.
    def dequeue!(user=nil)
      self.queued = false
      save
    end

    # Update the metadata surrounding playing a song.
    #
    # Returns a Boolean of whether we've saved the song.
    def play!
      Song.update_all(:now_playing => false)
      self.now_playing = true
      votes.update_all(:active => false)
      save
    end

    # Pull a magic song from a hat, depending on who's in the office.
    #
    # Returns a Song that's pulled from the favorite artists of the users
    # currently located in the office.
    def self.office_song
      users = Play::Office.users
      if !users.empty?
        artist = users.collect(&:favorite_artists).flatten.shuffle.first
      end
      song = artist.songs.shuffle.first
      song ||= Play::Song.order("rand()").first
      song
    end

    # Plays the next song in the queue. Updates the appropriate metainformation
    # in surrounding tables. Will pull an office favorite if there's nothing in
    # the queue currently.
    #
    # Returns the Song that was selected next to be played.
    def self.play_next_in_queue
      song = queue.first
      song ||= office_song
      Play::History.create(:song => song)
      song.play!
      song.dequeue!
      song
    end
  end
end
