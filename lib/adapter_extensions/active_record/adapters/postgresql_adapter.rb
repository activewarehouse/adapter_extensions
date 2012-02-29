require "active_record/connection_adapters/postgresql_adapter"
require "adapter_extensions/adapters/postgresql_adapter"

class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  include AdapterExtensions::PostgreSQLAdapter
end
