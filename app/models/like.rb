module Play
  class Like < ActiveRecord::Base
    belongs_to :user
  end
end