module Play
  # This defines a number of helper methods we can use all over the Sinatra side
  # of things.
  module Helpers

    # Public: Takes a collection of Song objects and renders that fucker in the
    # standardized JSON that clients parse out.
    #
    # This also merges our info on whether or not the current user has starred
    # the song into the song Hash.
    #
    # songs - An Array of Songs.
    # user  - The User object of the currently logged-in user.
    #
    # Returns a JSONified String.
    def songs_as_json(songs,user)
      songs.map! do |song|
        song.starred = user.starred?(song)
        song
      end

      hash = {
        :songs => songs
      }
      
      Yajl.dump hash
    end

  end
end
