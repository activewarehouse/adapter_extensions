module AdapterExtensions::MysqlAdapter

  def support_select_into_table?
    true
  end
  
  # Inserts an INTO table_name clause to the sql_query.
  def add_select_into_table(new_table_name, sql_query)
    "CREATE TABLE #{new_table_name} " + sql_query
  end
  
  # Copy the specified table.
  def copy_table(old_table_name, new_table_name)
    transaction do
      execute "CREATE TABLE #{new_table_name} LIKE #{old_table_name}"
      execute "INSERT INTO #{new_table_name} SELECT * FROM #{old_table_name}"
    end
  end

  def disable_keys(table)
    execute("ALTER TABLE #{table} DISABLE KEYS")
  end

  def enable_keys(table)
    execute("ALTER TABLE #{table} ENABLE KEYS")
  end

  def with_keys_disabled(table)
    disable_keys(table)
    yield
  ensure
    enable_keys(table)
  end      

protected
  # Call +bulk_load+, as that method wraps this method.
  # 
  # Bulk load the data in the specified file. This implementation always uses the LOCAL keyword
  # so the file must be found locally, not on the remote server, to be loaded.
  #
  # Options:
  # * <tt>:ignore</tt> -- Ignore the specified number of lines from the source file
  # * <tt>:columns</tt> -- Array of column names defining the source file column order
  # * <tt>:fields</tt> -- Hash of options for fields:
  # * <tt>:delimited_by</tt> -- The field delimiter
  # * <tt>:enclosed_by</tt> -- The field enclosure
  # * <tt>:replace</tt> -- Add in REPLACE to LOAD DATA INFILE command
  # * <tt>:disable_keys</tt> -- if set to true, disable keys, loads, then enables again
  def do_bulk_load(file, table_name, options={})
    return if File.size(file) == 0

    q = "LOAD DATA LOCAL INFILE '#{file}' #{options[:replace] ? 'REPLACE' : ''} INTO TABLE #{table_name}"
    if options[:fields]
      q << " FIELDS"
      q << " TERMINATED BY '#{options[:fields][:delimited_by]}'" if options[:fields][:delimited_by]
      q << " ENCLOSED BY '#{options[:fields][:enclosed_by]}'" if options[:fields][:enclosed_by]
    end
    q << " IGNORE #{options[:ignore]} LINES" if options[:ignore]
    q << " (#{options[:columns].map { |c| quote_column_name(c.to_s) }.join(',')})" if options[:columns]

    if options[:disable_keys]
      with_keys_disabled(table_name) { execute(q) }
    else
      execute(q)
    end
    
  end

end