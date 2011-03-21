module Play
  class Artist < ActiveRecord::Base
    has_many :songs
    has_many :albums
    has_many :votes

    # Queue up an artist. This will grab ten random tracks for this artist and
    # queue 'em up.
    #
    #   user - the User who is requesting the artist be queued
    #
    # Returns nothing.
    def enqueue!(user)
      songs.shuffle[0..9].collect do |song|
        song.enqueue!(user)
        song
      end
    end

  end
end
