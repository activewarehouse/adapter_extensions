require 'adapter_extensions/base'

class ActiveRecord::Base
  class << self
    # for 1.8.7, modules loaded more than once that use alias_method_chain will 
    # cause stack level too deep errors - make sure we avoid this
    unless self.instance_methods.include?('establish_connection_without_adapter_extensions')
      def establish_connection_with_adapter_extensions(*args)
        establish_connection_without_adapter_extensions(*args)
        ActiveSupport.run_load_hooks(:active_record_connection_established, connection_pool)
      end
      alias_method_chain :establish_connection, :adapter_extensions
    end
  end
end

ActiveSupport.on_load(:active_record_connection_established) do |connection_pool|
  AdapterExtensions.load_from_connection_pool connection_pool
end
