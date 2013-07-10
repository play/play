class ImagesController < ApplicationController
  skip_before_filter :auth_required, :music_required

  def art
    send_file("#{Dir.pwd}/public/images/art-placeholder.png", :disposition => 'inline')
  end
end
