class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :songs,   :title
    add_index :songs,   :album_id
    add_index :songs,   :artist_id
    add_index :artists, :name
    add_index :albums,  :name
    add_index :votes,   :song_id
    add_index :votes,   :user_id
    add_index :votes,   :artist_id
  end
 
  def self.down
    remove_index :songs,   :title
    remove_index :songs,   :album_id
    remove_index :songs,   :artist_id
    remove_index :artists, :name
    remove_index :albums,  :name
    remove_index :votes,   :song_id
    remove_index :votes,   :user_id
    remove_index :votes,   :artist_id
  end
end
