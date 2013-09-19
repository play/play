class SongPlay < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

  attr_accessible :song_path, :user, :channel

  # The song for this play.
  #
  # Returns a Song.
  def song
    Song.new(:path => song_path)
  end
end
