module Play
  # A buncha helpers we can include into things.
  module Helpers
    # Take a path/to/a/file.ext and return just `file`.
    #
    # Returns a String.
    def name_from_path(path)
      File.basename(path, '.*')
    end

    # We sometimes pull information from mpc as a sepecialized tuple in the
    # format:
    #
    #   artist :: song title :: path to the file on disk
    #
    # From there we can split on `::` to get these parts of the Song. This
    # method takes the tuple, handles the splitting, and exposes it as a
    # Hash.
    #
    # tuple - A String in the form `artist :: title :: path`.
    #
    # Returns a Song.
    def song_from_tuple(tuple)
      keys = tuple.split('::')
      Song.new(keys[0].strip, keys[1].strip, keys[2].strip)
    end

    # Shortcut to the Client.
    #
    # Returns a Client.
    def client
      Client.new
    end
  end
end