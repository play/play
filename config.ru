require File.expand_path(File.dirname(__FILE__) + '/app/play')
require File.expand_path(File.dirname(__FILE__) + '/app/live-update')
require 'sprockets'

assets = Sprockets::Environment.new
assets.append_path 'app/assets/css'
assets.append_path 'app/assets/javascripts'
assets.append_path 'app/assets/fonts'

Faye::WebSocket.load_adapter('thin')

map('/')            { run Play::App }
map('/assets')      { run assets }
map('/live-update') { run Play::LiveUpdate }