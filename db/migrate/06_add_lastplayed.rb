class AddLastPlayed < ActiveRecord::Migration
  def self.up
    add_column :songs, :last_played, :timestamp
  end

  def self.down
    remove_column :songs, :last_played
  end
end
