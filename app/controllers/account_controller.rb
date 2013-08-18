class AccountController < ApplicationController

  def show
    @user = current_user
    @plays = @user.favorite_songs
    render :template => 'users/show'
  end

end
