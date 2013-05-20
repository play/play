class Like < ActiveRecord::Base
  belongs_to :user

  attr_accessible :song_path
end