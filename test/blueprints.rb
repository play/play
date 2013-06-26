require 'machinist/active_record'

User.blueprint do
  login { 'holman' }
  email { 'email@example.com' }
end

Song.blueprint do
  path { 'Justice/Cross/Stress.mp3' }
end
