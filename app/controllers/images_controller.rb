class ImagesController < ApplicationController
  skip_before_filter :require_auth

  def art
    send_file("#{Dir.pwd}/public/images/art-placeholder.png", :disposition => 'inline')
  end
end
