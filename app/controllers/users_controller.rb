class UsersController < ApplicationController
  def show
    @user = User.find_by_login(params[:login])
    return render_404 if !@user

    @songs = @user.plays
  end
end
