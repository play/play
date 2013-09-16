class RemoveConfigPathFromChannel < ActiveRecord::Migration
  def change
    remove_column :channels, :config_path
  end
end
