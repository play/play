class SongPlay < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

  attr_accessible :song_path, :user, :channel

  scope :auto_queued, -> { where(:user_id => nil) }
  scope :manually_queued, -> { where('user_id is not null') }

  # The song for this play.
  #
  # Returns a Song.
  def song
    Song.new(:path => song_path)
  end
end
