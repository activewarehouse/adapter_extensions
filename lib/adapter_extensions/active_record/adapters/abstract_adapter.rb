require "adapter_extensions/adapters/abstract_adapter"

module ActiveRecord # :nodoc:
  module ConnectionAdapters # :nodoc:
    class AbstractAdapter # :nodoc:
      include AdapterExtensions::AbstractAdapter
    end
  end
end
