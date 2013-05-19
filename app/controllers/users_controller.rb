class UsersController < ApplicationController
  def show
    @user = User.find_by_login(params[:login])
    not_found if !@user

    @songs = @user.plays
  end
end
