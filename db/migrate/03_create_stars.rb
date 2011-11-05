class CreateStars < ActiveRecord::Migration
  def self.up
    create_table :stars do |t|
      t.belongs_to :user
      t.belongs_to :song

      t.timestamps
    end
  end
 
  def self.down
    drop_table :stars
  end
end
