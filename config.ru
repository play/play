require File.expand_path(File.dirname(__FILE__) + '/app/play')
require 'sprockets'

assets = Sprockets::Environment.new
assets.append_path 'app/assets/css'
assets.append_path 'app/assets/javascripts'
assets.append_path 'app/assets/images'

map('/assets')   { run assets }

map('/')         { run Play::App }