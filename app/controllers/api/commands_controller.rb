class Api::CommandsController < Api::BaseController

  def command
    # attempt to fetch a channel if the param is included
    if params[:channel]
      # if the param is blank, default to the first channel
      # otherwise attempt to find the specified channel
      channel = params[:channel].blank? ? Channel.first : Channel.find_by_name(params[:channel])
    end

    # check to see if a channel should be used
    # if none was found, error out
    if (params[:channel] && !channel)
      render :text => "Ooops, I don't know that channel. Is #{params[:channel]} even a channel?"
    else
      # otherwise process the command on the channel
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
