print "Using PostgreSQL\n"

ActiveRecord::Base.configurations = {
  'adapter_extensions_unittest' => {
    :adapter  => :postgresql,
    :username => 'postgres',
    :password => 'postgres',
    :host     => 'localhost',
    :database => 'adapter_extensions_unittest',
    :encoding => 'utf8',
    :setup_file => 'setup.sql',
  }
}

ActiveRecord::Base.establish_connection 'adapter_extensions_unittest'
conn = ActiveRecord::Base.connection
lines = open(
  File.join(File.dirname(__FILE__), 
  ActiveRecord::Base.configurations['adapter_extensions_unittest'][:setup_file])
).readlines
lines.join.split(';').each_with_index do |line, index|
  begin
    conn.execute(line)
  rescue => e
    #puts "failed to load line #{index}: #{e}"
  end
end