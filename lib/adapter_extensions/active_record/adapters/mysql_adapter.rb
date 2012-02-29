require "active_record/connection_adapters/mysql_adapter"
require "adapter_extensions/adapters/mysql_adapter"

class ActiveRecord::ConnectionAdapters::MysqlAdapter
  include AdapterExtensions::MysqlAdapter
end
