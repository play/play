class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users, :id => true do |t|
      t.column :login, :string
      t.column :email, :string
      t.column :token, :string
    end
  end

  def down
    drop_table :users
  end
end