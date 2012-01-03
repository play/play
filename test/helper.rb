require 'test/unit'

begin
  require 'rubygems'
  require 'redgreen'
  require 'leftright'
rescue LoadError
end

require 'rack/test'
require 'mocha'
require 'test/spec/mini'

ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'play'
include Play

def parse_json(json)
  Yajl.load(json, :symbolize_keys => true)
end