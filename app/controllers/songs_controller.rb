class SongsController < ApplicationController
  def show
    @artist = Artist.new(:name => params[:artist_name])
    @song   = @artist.songs.find{|song| song.title == params[:title]}
  end

  def create
    file    = params[:file]
    tmpfile = file.tempfile
    name    = file.original_filename.chomp.delete("\000")

    # taglib needs a file extension (lol)
    new_tmp = File.join(File.dirname(tmpfile), File.basename(name))
    File.rename(tmpfile.path, new_tmp)
    song    = Song.from_path(new_tmp)

    # Import into our collection
    path = File.join(Play.music_path, song.artist_name, song.album_name)
    FileUtils.mkdir_p(path)
    File.rename song.path, File.join(path, File.basename(song.path))

    # Update the index
    Play.library.update

    render :text => 'Uploaded!'
  end

  def search
    if record = Play.library.send_command(:find, :artist, params[:q]).first
      return redirect_to(artist_path(record[:artist]))
    end

    @filter = (params[:filter] || :any).to_sym
    @songs = Song.find([@filter, params[:q]], :current_page => params[:page])
  end

  def download
    song = Song.from_path(params[:path])
    send_file(File.join(Play.music_path,song.path), :disposition => 'attachment')
  end
end
