$:.unshift(File.dirname(__FILE__))

require 'test/unit'
require 'flexmock/test_unit'
require 'pp'

require File.dirname(__FILE__) + '/../lib/adapter_extensions'

############## TODO - move this to adapter_test.rb "setup before all" ##############################

raise "Missing required DB environment variable" unless ENV['DB']
configs = YAML.load_file('test/config/database.yml')
raise "Configuration #{ENV['DB']} not in database.yml!"
ActiveRecord::Base.configurations = configs
ActiveRecord::Base.establish_connection(ENV['DB'])

connection = ActiveRecord::Base.connection
connection.recreate_database(connection.current_database)
connection.reconnect!

def normalize_adapter_name(adapter_name)
  adapter_name == 'mysql2' ? 'mysql' : adapter_name
end

sql_setup = IO.read(File.dirname(__FILE__) + "/config/databases/#{normalize_adapter_name(ENV['DB'])}_setup.sql")
sql_setup.split(';').each { |line| connection.execute(line) }
