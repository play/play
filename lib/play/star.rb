module Play
  class Star < ActiveRecord::Base
    belongs_to :user
    belongs_to :song
  end
end
