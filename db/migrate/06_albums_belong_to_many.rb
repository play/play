class AlbumsBelongToMany < ActiveRecord::Migration
  def self.up
    remove_column :albums, :artist_id
  end

  def self.down
    change_table :albums do |t|
      t.integer :artist_id
    end
    # Uh, sorry, your album -> artist links are probably fucked now
  end
end
