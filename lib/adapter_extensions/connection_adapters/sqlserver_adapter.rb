# Source code for the SQLServerAdapter extensions.
module ActiveRecord #:nodoc:
  module ConnectionAdapters #:nodoc:
    # Adds new functionality to ActiveRecord SQLServerAdapter.
    class SQLServerAdapter < AbstractAdapter
      def support_select_into_table?
        true
      end
      
      # Inserts an INTO table_name clause to the sql_query.
      def add_select_into_table(new_table_name, sql_query)
        sql_query.sub(/FROM/i, "INTO #{new_table_name} FROM")
      end
      
      # Copy the specified table.
      def copy_table(old_table_name, new_table_name)
        execute add_select_into_table(new_table_name, "SELECT * FROM #{old_table_name}")
      end
          
      protected
      # Call +bulk_load+, as that method wraps this method.
      # 
      # Bulk load the data in the specified file. This implementation relies
      # on freebcp being in your PATH.
      #
      # Currently supported options:
      # * <tt>:bin</tt> -- alternate path to freebcp
      # * <tt>:max_errors</tt> -- maximum number of errors (freebcp -m parameter)
      # * <tt>:env</tt> -- override ActiveRecord environment to be used
      # * <tt>:fields</tt> -- Hash of options for fields:
      # * <tt>:delimited_by</tt> -- The field delimiter
      # :columns is currently unsupported and will raise an exception
      def do_bulk_load(filename, table_name, options={})
        env_name = options[:env] || Rails.env
        config = ActiveRecord::Base.configurations[env_name]

        raise NotImplementedError.new(":columns option is not currently supported") if options[:columns]

        # work in progress.
        # - http://linux.die.net/man/1/freebcp
        # - http://stackoverflow.com/a/924943/20302
        # - http://msdn.microsoft.com/en-us/library/ms162802.aspx
        # - http://www.dbforums.com/microsoft-sql-server/1624618-how-bring-out-column-names-bcp.html
        
        command = []
        command << (options[:bin] || 'freebcp')
        command << "\"#{config['database']}.dbo.#{table_name}\""
        command << "in \"#{filename}\""
        command << "-S \"#{config['host']}\""
        command << "-U \"#{config['username']}\""
        command << "-P \"#{config['password']}\""
        command << "-c" # character mode
        command << "-t \"#{options[:fields][:delimited_by]}\"" if options[:fields] && options[:fields][:delimited_by]
        command << "-b 10000" # bulk size

        command << "-m #{options[:max_errors]}" if options[:max_errors]
        command << "-e \"#{filename}.in.errors\""
        command = command.join(' ')

        # left-overs from legacy bcp call - must see if they must remain or not
        # -a8192 -q -E 

        # TODO - raise a better exception here
        raise "bulk load failed!" unless Kernel.system(command)
      end
    end
  end
end