class CreatePlays < ActiveRecord::Migration
  def up
    create_table :song_plays do |t|
      t.belongs_to :user
      t.belongs_to :song
      t.timestamps
    end
  end

  def down
    drop_table :song_plays
  end
end