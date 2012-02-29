require "active_record/connection_adapters/mysql2_adapter"
require "adapter_extensions/adapters/mysql_adapter"

class ActiveRecord::ConnectionAdapters::Mysql2Adapter
  include AdapterExtensions::MysqlAdapter
end
