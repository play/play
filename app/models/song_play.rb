class SongPlay < ActiveRecord::Base
  belongs_to :user

  attr_accessible :song_path, :user

  # The song for this play.
  #
  # Returns a Song.
  def song
    Song.new(:path => song_path)
  end
end
