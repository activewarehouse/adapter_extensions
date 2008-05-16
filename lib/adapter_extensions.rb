# Extensions to the Rails ActiveRecord adapters.
#
# Requiring this file will require all of the necessary files to function.

puts "Using AdapterExtensions"

require 'rubygems'
unless Kernel.respond_to?(:gem)
  Kernel.send :alias_method, :gem, :require_gem
end

unless defined?(ActiveSupport)
  gem 'activesupport'
  require 'active_support'
end

unless defined?(ActiveRecord)
  gem 'activerecord'
  require 'active_record'
end

$:.unshift(File.dirname(__FILE__))
Dir[File.dirname(__FILE__) + "/adapter_extensions/**/*.rb"].each { |file| require(file) }