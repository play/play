class LikesController < ApplicationController
  def index
    @user = User.find_by_login(params[:login])
    not_found if !@user

    @songs = @user.liked_songs
    render 'users/show'
  end

  def create
    current_user.like(params[:id])
    render :nothing => true
  end

  def destroy
    current_user.unlike(params[:id])
    render :nothing => true
  end
end
