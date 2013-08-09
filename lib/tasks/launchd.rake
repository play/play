def plist_path
  File.expand_path("~/Library/LaunchAgents/com.play.plist")
end

def log_path
  File.expand_path("~/Library/Logs/play.log")
end

desc "Uninstall launch plist from launchd"
task :uninstall do
  puts "Removing Play from launchd"

  if File.exist?(plist_path)
    `launchctl unload -w #{plist_path}`
  end

end

desc "Install launch plist for launchd"
task :install do
  puts "Setting up Play in launchd"

  plist = %{
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.play.plist</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>LC_ALL</key>
          <string>en_US.UTF-8</string>
          <key>PATH</key>
          <string>~/.rbenv/shims:/usr/local/bin:/usr/bin:</string>
          <key>RAILS_ENV</key>
          <string>production</string>
          <key>RACK_ENV</key>
          <string>production</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>script/play</string>
        </array>
        <key>OnDemand</key>
        <false/>
        <key>AbandonProcessGroup</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{File.join(File.dirname(__FILE__), '..', '..')}</string>
        <key>StandardErrorPath</key>
        <string>#{log_path}</string>
        <key>StandardOutPath</key>
        <string>#{log_path}</string>
      </dict>
    </plist>
  }

  `touch #{log_path}`

  File.open(plist_path, 'w+') do |f|
    f.puts plist
  end

  `launchctl load -w #{plist_path}`
end
