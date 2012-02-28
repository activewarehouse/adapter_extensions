require 'bundler'
Bundler::GemHelper.install_tasks
require 'rake'
require 'rake/testtask'
require 'rdoc'
require 'rdoc/task'

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
    when /postgres/;
      system! "psql -c 'create database adapter_extensions_test;' -U postgres"
    else abort("I don't know how to create the database for DB=#{ENV['DB']}!")
  end
end

namespace :rcov do
  desc 'Measures test coverage'
  task :test do
    rm_f 'coverage.data'
    mkdir 'coverage' unless File.exist?('coverage')
    rcov = "rcov --aggregate coverage.data --text-summary -Ilib"
    system("#{rcov} test/*_test.rb test/**/*_test.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
end

desc 'Generate documentation for the AdapterExtensions library.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Extensions for Rails adapters'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Generate code statistics"
task :lines do
  lines, codelines, total_lines, total_codelines = 0, 0, 0, 0

  for file_name in FileList["lib/**/*.rb"]
    next if file_name =~ /vendor/
    f = File.open(file_name)

    while line = f.gets
      lines += 1
      next if line =~ /^\s*$/
      next if line =~ /^\s*#/
      codelines += 1
    end
    puts "L: #{sprintf("%4d", lines)}, LOC #{sprintf("%4d", codelines)} | #{file_name}"
    
    total_lines     += lines
    total_codelines += codelines
    
    lines, codelines = 0, 0
  end

  puts "Total: Lines #{total_lines}, LOC #{total_codelines}"
end

desc "Publish the API documentation (UNTESTED CURRENTLY)"
task :pdoc => [:rdoc] do 
  Rake::SshDirPublisher.new("aeden@rubyforge.org", "/var/www/gforge-projects/activewarehouse/adapter_extensions/rdoc", "rdoc").upload
end
