module Play
  class Like < ActiveRecord::Base
    belongs_to :user

    validates :value, :inclusion => { :in => [1,0,-1], :message => "%{value} is not a valid value" }
  end
end