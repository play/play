module Play
  # This defines a number of helper methods we can use all over the Sinatra side
  # of things.
  module Helpers

    # Public: Takes a collection of Song objects and renders that fucker in the
    # standardized JSON that clients parse out.
    #
    # songs - An Array of Songs.
    #
    # Returns a JSONified String.
    def songs_as_json(songs)
      hash = {
        :songs => songs
      }
      
      Yajl.dump hash
    end

  end
end
