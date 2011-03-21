module Play
  class Album < ActiveRecord::Base
    has_many :songs
    belongs_to :artist
  end
end
