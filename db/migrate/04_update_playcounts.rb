class UpdatePlaycounts < ActiveRecord::Migration
  def self.up
    Play::History.connection.execute("UPDATE songs SET playcount = (SELECT count(song_id) FROM histories WHERE song_id = songs.id)")
  end

  def self.down
    # no-op
  end
end
