require 'test/unit'

begin
  require 'rubygems'
  require 'redgreen'
  require 'leftright'
rescue LoadError
end

require 'rack/test'
require 'mocha'
require 'spec/mini'

ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))

require 'boot'
include Play
include Rack::Test::Methods

def app
  Play::App
end

def parse_json(json)
  Yajl.load(json, :symbolize_keys => true)
end