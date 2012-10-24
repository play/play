module Play
  class User < ActiveRecord::Base
    validates_presence_of :login

    has_many :song_plays, :order => 'song_plays.created_at DESC'

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
  end
end