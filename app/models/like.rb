class Like < ActiveRecord::Base
  belongs_to :user

  attr_accessible :song_path, :user

  def song
    Song.from_path(song_path)
  end
end
