module Play
  class SongPlay < ActiveRecord::Base
    belongs_to :user
  end
end