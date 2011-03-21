module Play
  class Vote < ActiveRecord::Base
    belongs_to :song
    belongs_to :user
    belongs_to :artist
  end
end
