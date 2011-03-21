module Play
  class History < ActiveRecord::Base
    belongs_to :song

    validates_presence_of :song
  end
end
