module Play
  # API endpoints dealing with managing your Queue.
  class App < Sinatra::Base

    get "/queue" do
      songs_as_json(Queue.songs,current_user)
    end

    post "/queue" do
      if params[:id]
        songs = [Song.find(params[:id])]
      elsif params[:album] && params[:artist]
        album = Album.new(params[:album], params[:artist])
        songs = album.songs
      else
        songs = [Song.new(:name => params[:name], :artist => params[:artist])]
      end

      songs.each do |song|
        Queue.add_song(song)
        History.add(song,current_user)
      end
      songs_as_json(songs, current_user)
    end

    delete "/queue" do
      if params[:id]
        songs = [Song.find(params[:id])]
      elsif params[:album] && params[:artist]
        album = Album.new(params[:album], params[:artist])
        songs = album.songs
      else
        songs = [Song.new(:name => params[:name], :artist => params[:artist])]
      end

      songs.each do |song|
        Queue.remove_song(song)
      end
      true
    end

    delete "/queue/all" do
      Queue.clear
      true
    end

    post "/queue/stars" do
      songs = current_user.stars.shuffle[0..4]
      songs.each do |song|
        Queue.add_song(song)
        History.add(song,current_user)
      end

      songs_as_json(songs,current_user)
    end

    post "/freeform" do
      subject = params[:subject]

      # Do we have an Artist match?
      songs = Artist.new(subject).songs
      if songs.size > 0
        songs = songs.shuffle[0..9]
        songs.each do |song|
          Queue.add_song(song)
          History.add(song,current_user)
        end
        return songs_as_json(songs,current_user)
      end

      # No? Maybe we have an album.
      songs = Album.songs_by_name(subject)
      if songs.size > 0
        songs.each do |song|
          Queue.add_song(song)
          History.add(song,current_user)
        end
        return songs_as_json(songs,current_user)
      end

      # Well maybe the shit's just a song.
      song = Song.find_by_name(subject)
      if song
        Queue.add_song(song)
        History.add(song,current_user)
        return songs_as_json([song],current_user)
      end
    end

  end
end