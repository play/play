namespace :v2 do
  desc "Import a v2 dump into v3"
  task :import => :environment do
    file = open("v2.json")
    json = file.read

    parsed = JSON.parse(json)

    parsed[:users].each do |user|
      User.create \
        :login => user[:login],
        :email => user[:email],
        :token => user[:token]

        stars users[:stars]
    end

    parsed[:plays].each do |play|
      relative_path = play[:path].split('/').last(3).join('/')

      ActiveRecord::Base.record_timestamps = false

      SongPlay.create \
        :created_at => play[:date],
        :updated_at => play[:date],
        :song_path  => play[:path],
        :user       => User.find_by_login(play[:requested_by])

      ActiveRecord::Base.record_timestamps = true
    end
  end
end
