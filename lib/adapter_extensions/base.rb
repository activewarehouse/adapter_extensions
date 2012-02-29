require "pathname"
require "active_record"
require "active_record/version"

module AdapterExtensions
  AdapterPath = File.join File.expand_path(File.dirname(__FILE__)), "/active_record/adapters"

  # Loads the extensions for a specific database adapter
  def self.require_adapter(adapter)
    require File.join(AdapterPath,"/abstract_adapter")
    specific_adapter = File.join(AdapterPath,"/#{adapter}_adapter")
    require specific_adapter if File.exists?(specific_adapter + '.rb')
  end

  def self.load_from_connection_pool(connection_pool)
    require_adapter connection_pool.spec.config[:adapter]
  end

end