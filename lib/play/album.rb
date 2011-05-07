module Play
  class Album < ActiveRecord::Base
    has_many :songs
    belongs_to :artist

    # Queue up an entire ALBUM!
    #
    #   user - the User who is requesting the album to be queued
    #
    # Returns nothing.
    def enqueue!(user)
      songs.each{ |song| song.enqueue!(user) }
    end
  end
end
