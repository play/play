namespace :db do
  desc "Check if we have channels"
  task :channels_exist => [:environment] do
    Channel.count > 0
  end

  desc "Create an initial channel"
  task :create_initial_channel => [:environment] do
    Channel.new(:name => "Play", :color => "000000").save
  end
end
