namespace :channels do
  desc "Start the MPDs"
  task :start => [:environment] do
    Play.start_servers
  end

  desc "Stop the MPDs"
  task :stop => [:environment] do
    Play.stop_servers
  end
end

namespace :db do
  desc "Check if we have channels"
  task :channels_exist => [:environment] do
    Channel.count > 0 || exit(1)
  end

  desc "Create an initial channel"
  task :create_initial_channel => [:environment] do
    Channel.new(:name => "Play", :color => "000000").save
  end
end
