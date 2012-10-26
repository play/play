module Play
  class User < ActiveRecord::Base
    validates_presence_of :login
    validates_uniqueness_of :login

    has_many :song_plays, :order => 'song_plays.created_at DESC'

    has_many :likes

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

    # Like a Song.
    #
    # Returns nothing.
    def like(path)
      unlike(path)

      like = likes.create(:song_path => path, :value => 1)
    end

    # Unlike a Song. Basically clear out anything we know about this user and
    # this song path.
    #
    # Returns nothing.
    def unlike(path)
      likes.where(:song_path => path).delete_all
    end

    # Dislike a Song.
    #
    # Returns nothing.
    def dislike(path)
      unlike(path)

      likes.create(:song_path => path, :value => -1)
    end
  end
end