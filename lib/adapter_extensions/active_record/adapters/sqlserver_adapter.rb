require "activerecord-sqlserver-adapter"
require "adapter_extensions/adapters/sqlserver_adapter"

class ActiveRecord::ConnectionAdapters::SQLServerAdapter
  include AdapterExtensions::SQLServerAdapter
end
