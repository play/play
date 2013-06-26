require 'machinist/active_record'

Artist.blueprint do
  name { 'Justice' }
end

Song.blueprint do
  path { 'Justice/Cross/Stress.mp3' }
end

SongPlay.blueprint do
  song_path { 'Justice/Cross/Stress.mp3' }
end

User.blueprint do
  login { 'holman' }
  email { 'email@example.com' }
end
