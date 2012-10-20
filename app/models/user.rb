module Play
  class User < ActiveRecord::Base
    validates_presence_of :login
  end
end