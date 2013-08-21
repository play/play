class Like < ActiveRecord::Base
  belongs_to :user

  attr_accessible :song_path, :user

  def song
    Song.new(:path => song_path)
  end
end
