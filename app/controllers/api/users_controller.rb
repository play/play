class Api::UsersController < Api::BaseController

  def index
    users = User.all
    deliver_json(200, {:users => users.collect(&:to_hash)})
  end

  def show
    user = User.find_by_login(params[:login])
    deliver_json(200, user.to_hash)
  end

  def likes
    current_page = params[:page] || 1

    user = User.find_by_login(params[:login])
    likes = user.liked_songs(current_page)

    deliver_json(200, songs_response(likes, current_user).merge(:total_entries => user.likes.count))
  end

end
