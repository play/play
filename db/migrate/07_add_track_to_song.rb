class AddTrackToSong < ActiveRecord::Migration
  def self.up
    change_table :songs do |t|
      t.integer :track
    end
  end

  def self.down
    remove_column :songs, :track
  end
end 
