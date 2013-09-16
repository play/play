# Start all of the channels

Channel.all.each do |channel|
  channel.start

  if !Rails.env.test? && channel.mpd

    # Set up mpd to natively consume songs
    channel.mpd.repeat  = true
    channel.mpd.consume = true

    # Scan for new songs just in case
    channel.mpd.update

    # Play the tunes
    channel.mpd.play
  end
end
