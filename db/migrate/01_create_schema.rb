class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string  :title
      t.string  :path
      t.integer :artist_id
      t.integer :album_id
      t.integer :playcount
      t.boolean :queued, :default => false
      t.boolean :now_playing, :default => false
      t.timestamps
    end

    create_table :artists do |t|
      t.string  :name
      t.timestamps
    end

    create_table :albums do |t|
      t.string  :name
      t.integer :artist_id
      t.timestamps
    end

    create_table :users do |t|
      t.string :login
      t.string :name
      t.string :email
      t.string :office_string
      t.string :alias
    end

    create_table :votes do |t|
      t.integer :song_id
      t.integer :user_id
      t.integer :artist_id
      t.boolean :active, :default => true
      t.timestamps
    end

    create_table :histories do |t|
      t.integer :song_id
      t.integer :artist_id
      t.timestamps
    end
  end
 
  def self.down
    drop_table :songs
    drop_table :artists
    drop_table :albums
    drop_table :queues
    drop_table :votes
  end
end
