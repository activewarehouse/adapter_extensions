print "Using native MySQL\n"

#require 'logger'
#ActiveRecord::Base.logger = Logger.new("debug.log")

ActiveRecord::Base.configurations = {
  'adapter_extensions_unittest' => {
    :adapter  => :mysql,
    :username => 'root',
    :host     => 'localhost',
    :database => 'adapter_extensions_unittest',
    :encoding => 'utf8',
    :setup_file => 'setup.sql',
  }
}

ActiveRecord::Base.establish_connection 'adapter_extensions_unittest'

puts "Resetting database"
conn = ActiveRecord::Base.connection
conn.recreate_database(conn.current_database)
conn.reconnect!
lines = open(
  File.join(File.dirname(__FILE__), 
  ActiveRecord::Base.configurations['adapter_extensions_unittest'][:setup_file])
).readlines
lines.join.split(';').each { |line| conn.execute(line) }