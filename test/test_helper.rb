$:.unshift(File.dirname(__FILE__))

require 'test/unit'
require 'rubygems'
require 'flexmock/test_unit'
require 'pp'

require File.dirname(__FILE__) + '/../lib/adapter_extensions'

db = ENV['DB'] ||= 'mysql'
require "connection/#{db}/connection"