class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.column :name, :string
      t.column :color, :string
      t.column :mpd_port, :integer
      t.column :httpd_port, :integer
      t.column :config_path, :string
      t.timestamps
    end

    change_table :users do |t|
      t.column :channel_id, :integer
    end

  end
end
