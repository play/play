class Api::CommandsController < Api::BaseController
  def create
    user = User.find_by_login(params[:login]) if params[:login].present?
    channel = Channel.find_by_name(params[:channel])

    if (!params[:channel].blank? && !channel)
      render :text => "Ooops, I don't know that channel. You're currently tuned to #{params[:channel]}. Maybe it's wrong?"
    else
      command = normalize_command(params[:command])
      output = Play::Commands.process_command(command, channel, current_user)
      render :text => output
    end
  end

  protected

  def normalize_command(command)
    (command || "")
      .strip                    # no leading/trailing spaces
      .gsub(/\s+/, " ")         # make sure all spaces, no newlines or tabs, and no doubles
      .gsub(/^(\/|hubot )/, '') # strip leading / or hubt
  end

end
