require File.expand_path(File.dirname(__FILE__) + '/app/boot')
require 'sprockets'

stylesheets = Sprockets::Environment.new
stylesheets.append_path 'app/frontend/styles'

javascripts = Sprockets::Environment.new
javascripts.append_path 'app/frontend/scripts'

map("/css")      { run stylesheets }
map("/js")       { run javascripts }

map('/')         { run Play::App }