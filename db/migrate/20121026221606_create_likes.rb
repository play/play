class CreateLikes < ActiveRecord::Migration
  def up
    create_table :likes do |t|
      t.belongs_to :user
      t.string :song_path
      t.integer :value, :default => 0
      t.timestamps
    end
  end

  def down
    drop_table :likes
  end
end