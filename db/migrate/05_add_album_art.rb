class AddAlbumArt < ActiveRecord::Migration
  def self.up
    add_column :albums, :art_url, :string
  end

  def self.down
    remove_column :albums, :art_url
  end
end
