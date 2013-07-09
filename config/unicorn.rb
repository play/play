# unicorn -c unicorn.rb

if File.exist?("/tmp/play/web.log")
  stderr_path "/tmp/play/web.log"
  stdout_path "/tmp/play/web.log"
end

rack_env = ENV['RAILS_ENV'] || 'production'
root =
  if ENV['RACK_ROOT']
    ENV['RACK_ROOT']
  elsif File.exist?('config/unicorn.rb')
    Dir.pwd
  end
worker_processes 2
preload_app true
timeout 60

# create log and tmp directories
%w[tmp tmp/sockets tmp/pids log].each do |dir|
  Dir.mkdir "#{root}/#{dir}" unless File.directory?("#{root}/#{dir}")
end

pid "#{root}/tmp/pids/unicorn.pid"

if rack_env != 'development'
  listen "#{root}/tmp/sockets/unicorn.sock", :backlog => 2048
else
  # Keep things nice for those on Boxen
  if ENV["BOXEN_SOCKET_DIR"]
    listen "#{ENV['BOXEN_SOCKET_DIR']}/play", :backlog => 2048
  else
    listen "127.0.0.1:9393"
  end
end

##
# Log Tailer
if rack_env == 'development'
  # make sure the development.log exists
  File.open("#{root}/log/development.log", 'ab') { }

  # fork off a tail process on development.log. unicorn will reap this on clean
  # shutdown but not when there's a boot error so kill it on process exit.
  tailer = fork { exec "tail", "-n", "0", "-f", "#{root}/log/development.log" }
  at_exit do
    begin
      Process.kill('KILL', tailer)
      Process.wait(tailer)
    rescue => boom
    end
  end

  # write stuff to console immediately
  $stderr.sync = true
  $stdout.sync = true
end

# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

after_fork do |server, worker|
  $0 = $0.sub(/unicorn/, "unicorn - play[#{`cd #{root} && git rev-parse HEAD`[0..7]}]")
end

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = root + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
