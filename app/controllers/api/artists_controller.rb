class Api::ArtistsController < Api::BaseController

  def index
    deliver_error(406, {:message => 'NOT IMPLEMENTED'})
  end

  def show
    artist = Artist.new(:name => params[:artist_name])
    deliver_json(200, artist.to_hash)
  end

end
