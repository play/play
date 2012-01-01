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
require 'running_man'
require 'running_man/active_record_block'

ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'play'
include Play

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3',
                                        :database => ":memory:")
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate("db/migrate")

RunningMan.setup_on ActiveSupport::TestCase, :ActiveRecordBlock

class Play::Album
  def fetch_art
    # no-op
  end
end

def parse_json(json)
  Yajl.load(json, :symbolize_keys => true)
end
