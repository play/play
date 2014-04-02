class QueueController < ApplicationController
  def index
    @songs = PlayQueue.songs
  end

  def create
    case params[:type]
    when /song/
      song = Song.new(:path => params[:id])
      PlayQueue.add(song,current_user)
    when /album/
      artist = Artist.new(:name => params[:artist])
      album  = Album.new(:artist => artist, :name => params[:name])
      album.songs.each{|song| PlayQueue.add(song, current_user)}
    end

    render :text => 'added!'
  end

  def destroy
    song = Song.new(:path => params[:id])
    PlayQueue.remove(song,current_user)
    render :text => 'deleted!'
  end

  def refresh
    current_id = params[:id]

    unless current_id == PlayQueue.now_playing.path
      @songs = PlayQueue.songs
      queue = render_to_string :partial => "shared/song", :collection => PlayQueue.songs
      sidebar = render_to_string :partial => 'shared/sidebar'
      if request.xhr?
        respond_to do |format|
          format.js
        end
        return
      end
    end

    render :text => "not yet"
  end
end
