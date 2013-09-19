class ChannelsController < ApplicationController
  before_filter :find_channel

  def show
    @songs = @channel.queue
    render 'queue/index'
  end

  def create
    case params[:type]
    when /song/
      song = Song.new(:path => params[:id])
      @channel.add(song,current_user)
    when /album/
      artist = Artist.new(:name => params[:artist])
      album  = Album.new(:artist => artist, :name => params[:name])
      album.songs.each{|song| @channel.add(song, current_user)}
    end

    render :text => 'added!'
  end

  def destroy
    song = Song.new(:path => params[:id])
    @channel.remove(song,current_user)
    render :text => 'deleted!'
  end
end
