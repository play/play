class AddLibraries < ActiveRecord::Migration
  def self.up
    add_column :songs, :library_type, :string
    Play::Song.connection.execute("UPDATE songs SET library_type = 'Play::Local::Library'")
  end

  def self.down
    remove_column :songs, :library_type
  end
end