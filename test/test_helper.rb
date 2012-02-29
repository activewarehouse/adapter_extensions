$:.unshift(File.dirname(__FILE__))

require 'test/unit'
require 'flexmock/test_unit'
require 'pp'
require 'ap'

require 'active_record'
require File.dirname(__FILE__) + '/../lib/adapter_extensions'
require 'adapter_extensions'