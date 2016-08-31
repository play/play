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
    # songs and user are both required. If they are not the return JSON
    # string will contain the "songs" key with an empty array.
    #
    # Returns a JSONified String.
    def songs_as_json(songs,user)
      if songs && user
        songs.map! do |song|
          song.starred = user.starred?(song)
          song.to_hash
        end
      else
        songs = nil
      end

      hash = {
        :songs => songs || []
      }

      Yajl.dump hash
    end

    # Public: Takes a collection of Song objects with an associated score and 
    # renders JSON as above in songs_to_json.
    #
    # Returns a JSONified String.
    def scored_songs_as_json(scored_songs,user)
      if scored_songs && user
        songs = scored_songs.map do |song,score|
          song.starred = user.starred?(song)
          song.to_hash.merge(:score => score)
        end
      else
        songs = nil
      end

      hash = {
        :songs => songs || []
      }

      Yajl.dump hash
    end

  end
end
