Rails.application.config.middleware.use OmniAuth::Builder do
  auth=YAML::load(File.open('config/play.yml'))
  provider :github, auth['github']['client_id'], auth['github']['secret'], scope: "user"
end
