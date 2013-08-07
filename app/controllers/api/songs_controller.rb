class Api::SongsController < Api::BaseController
  before_filter :find_song

  def show
    deliver_json(200, song_response(@song, current_user))
  end

  def download
    send_file(File.join(Play.music_path,@song.path), :disposition => 'attachment')
  end

  def like
    current_user.like(@song.path)

    deliver_json(200, song_response(@song, current_user))
  end

  def unlike
    current_user.unlike(@song.path)

    deliver_json(200, song_response(@song, current_user))
  end

  private

  def find_song
    artist = Artist.new(:name => params[:artist_name])
    @song = artist.songs.find{|song| song.title == params[:song_name]}
  end


end
