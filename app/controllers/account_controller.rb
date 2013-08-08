class AccountController < ApplicationController

  def show
    @user = current_user
    render :template => 'users/show'
  end

end
