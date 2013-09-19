class WelcomeController < ApplicationController
  def index
    @channels = Channel.all
    render :layout => 'welcome'
  end
end
