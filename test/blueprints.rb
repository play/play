require 'machinist/active_record'

User.blueprint do
  login { 'holman' }
  email { 'email@example.com' }
end