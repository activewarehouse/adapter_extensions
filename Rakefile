require 'bundler'
Bundler::GemHelper.install_tasks
require 'rake'
require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the ETL application.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  # TODO: reset the database
end

def system!(cmd)
  puts cmd
  raise "Command failed!" unless system(cmd)
end

task :create_test_db do
  case ENV['DB']
    when /mysql/;
      # TODO - extract this info from database.yml
      system! "mysql -e 'create database adapter_extensions_test;'"
      system! "mysql adapter_extensions_test < test/config/databases/mysql_setup.sql"
    when /postgres/;
      system! "psql -c 'create database adapter_extensions_test;' -U postgres"
      system! "psql -d adapter_extensions_test -U postgres -f test/config/databases/postgresql_setup.sql"
    else abort("I don't know how to create the database for DB=#{ENV['DB']}!")
  end
end

# experimental task to reproduce the Travis behaviour locally - TODO: find if there's something in Travis for this?
task :local_travis, :db do |t, args|
  ENV['BUNDLE_GEMFILE'] = File.expand_path(File.dirname(__FILE__) + '/test/config/gemfiles/Gemfile.rails-3.2.x')
  ENV['DB'] = args[:db] || 'mysql2'
  system! 'bundle install'
  system! 'bundle exec rake'
end
