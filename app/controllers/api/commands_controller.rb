class Api::CommandsController < Api::BaseController
  def create
    user = User.find_by_login(params[:login]) if params[:login].present?
    channel = Channel.find_by_name(params[:channel])

    command = (params[:command] || "")
                .strip            # no leading/trailing spaces
                .gsub(/\s+/, " ") # make sure all spaces, no newlines or tabs, and no doubles


    case command
    when /^sup$/
      song = channel.now_playing
      output = %{Now playing on #{channel.name}: "#{song.title}" by #{song.artist_name}, from "#{song.album_name}"}
    else
      output = "lol wut"
    end

    render :text => output
  end
end
