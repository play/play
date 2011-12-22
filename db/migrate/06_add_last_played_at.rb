class AddLastPlayedAt < ActiveRecord::Migration
  def self.up
    add_column :songs, :last_played_at, :datetime
  end

  def self.down
    remove_column :songs, :last_played
  end
end
