class SongsController < ApplicationController
  def show
    @artist = Artist.new(CGI.unescape(params[:artist_name]))
    @song   = @artist.songs.find{|song| song.title == CGI.unescape(params[:title])}
  end

  def create
    params[:files].each do |file|
      tmpfile = file[:tempfile]
      name    = file[:filename].chomp.delete("\000")

      # taglib needs a file extension (lol)
      new_tmp = File.join(File.dirname(tmpfile), File.basename(name))
      File.rename(tmpfile.path, new_tmp)
      song    = Song.new(new_tmp)

      # Import into our collection
      path = File.join(Play.music_path, song.artist_name, song.album_name)
      FileUtils.mkdir_p(path)
      File.rename song.path, File.join(path, File.basename(song.path))
    end

    true
  end

  def search
    @filter = (params[:filter] || :any).to_sym
    @songs = Song.find([@filter,params[:q]])
  end

  def download
    song = Song.new(CGI.unescape(params[:path]))
    send_file(File.join(Play.music_path,song.path), :disposition => 'attachment')
  end
end
