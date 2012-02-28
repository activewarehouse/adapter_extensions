$:.unshift(File.dirname(__FILE__))

require 'test/unit'
require 'flexmock/test_unit'
require 'pp'

require File.dirname(__FILE__) + '/../lib/adapter_extensions'

############## TODO - move this to adapter_test.rb "setup before all" ##############################

raise "Missing required DB environment variable" unless ENV['DB']
configs = YAML.load_file('test/config/database.yml')
raise "Configuration #{ENV['DB']} not in database.yml!" unless configs[ENV['DB']]
ActiveRecord::Base.configurations = configs
ActiveRecord::Base.establish_connection(ENV['DB'])
