class AddChannelToSongPlay < ActiveRecord::Migration
  def change
    add_column :song_plays, :channel_id, :integer
  end
end
