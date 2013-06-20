class UsersController < ApplicationController
  def show
    @user = User.find_by_login(params[:login])
    return render_404 if !@user

    @plays = SongPlay.where(:user_id => @user.id).
              group(:song_path).
              select("song_plays.*, count(song_path) AS playcount").
              order("playcount DESC").
              limit(10)
  end

  def history
    @user = User.find_by_login(params[:login])
    return render_404 if !@user

    @songs = @user.plays
  end
end
