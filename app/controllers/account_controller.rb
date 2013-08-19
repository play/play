class AccountController < ApplicationController

  def show
    @user = current_user
    @plays = @user.favorite_songs
    render :template => 'users/show'
  end

  def token
    if params[:back_to]
      redirect_to params[:back_to] + "?token=" + current_user.token
    else
      redirect_to account_url
    end
  end

end
