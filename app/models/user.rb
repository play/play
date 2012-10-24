module Play
  class User < ActiveRecord::Base
    validates_presence_of :login

    has_many :plays, :foreign_key => 'user_id', :class_name => "SongPlay"
  end
end