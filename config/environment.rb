# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Play::Application.initialize!


if Rails.env.production?
  DNSSD.register Socket.gethostname, '_play._tcp', nil, 3030
end
