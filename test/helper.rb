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
ENV['CI'] = '1' if !RUBY_PLATFORM.downcase.include?("darwin")

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

def authorized_rack_header
  user = User.create('maddox', 'maddox@github.com')
  {"HTTP_AUTHORIZATION" => user.token}
end

def authorized_get(uri, opts={})
  get uri, opts, authorized_rack_header
end

def authorized_post(uri, opts={})
  post uri, opts, authorized_rack_header
end

def authorized_put(uri, opts={})
  put uri, opts, authorized_rack_header
end

def authorized_delete(uri, opts={})
  delete uri, opts, authorized_rack_header
end

def unauthorized_get(uri, opts={})
  rack_env = {"HTTP_AUTHORIZATION" => "xxxxxxxxxxxxxxxxxx"}
  get uri, opts, rack_env
end




