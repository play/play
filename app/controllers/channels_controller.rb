class ChannelsController < ApplicationController
  before_filter :set_channel

  def show
    @songs = @channel.queue
  end

  def add
    case params[:type]
    when /song/
      song = Song.new(:path => params[:song_id])
      @channel.add(song,current_user)
    when /album/
      artist = Artist.new(:name => params[:artist])
      album  = Album.new(:artist => artist, :name => params[:name])
      album.songs.each{|song| @channel.add(song, current_user)}
    end

    render :text => 'added!'
  end

  def remove
    song = Song.new(:path => params[:song_id])
    @channel.remove(song,current_user)
    render :text => 'deleted!'
  end

  private

  def set_channel
    @channel = Channel.find(params[:id])
    session[:channel_id] = @channel.id
    @channel
  end
end
