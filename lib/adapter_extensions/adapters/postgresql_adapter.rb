module AdapterExtensions::PostgreSQLAdapter

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

  def do_bulk_load(file, table_name, options={})
    on_client = options.key?(:client) && options[:client]

    if on_client
      do_bulk_load_on_client(file, table_name, options)
    else
      do_bulk_load_on_server(file, table_name, options)
    end
  end

  # Call +bulk_load+, as that method wraps this method.
  #
  # Bulk load the data in the specified file.
  #
  # Options:
  # * <tt>:ignore</tt> -- Ignore the specified number of lines from the source file. In the case of PostgreSQL
  #   only the first line will be ignored from the source file regardless of the number of lines specified.
  # * <tt>:columns</tt> -- Array of column names defining the source file column order
  # * <tt>:fields</tt> -- Hash of options for fields:
  # * <tt>:delimited_by</tt> -- The field delimiter
  # * <tt>:null_string</tt> -- The string that should be interpreted as NULL (in addition to \N)
  # * <tt>:enclosed_by</tt> -- The field enclosure
  def do_bulk_load_on_server(file, table_name, options={})
    q = build_copy_command(table_name, options, "'#{File.expand_path(file)}'")
    execute(q)
  end

  DEFAULT_BUFFER_SIZE = 256

  # Call +bulk_load+, as that method wraps this method.
  #
  # Bulk load the data in the specified file by streaming the data from the
  # client. This makes bulk import possible on hosted services like Heroku.
  #
  # Options:
  # * <tt>:ignore</tt> -- Ignore the specified number of lines from the source file. In the case of PostgreSQL
  #   only the first line will be ignored from the source file regardless of the number of lines specified.
  # * <tt>:columns</tt> -- Array of column names defining the source file column order
  # * <tt>:fields</tt> -- Hash of options for fields:
  # * <tt>:delimited_by</tt> -- The field delimiter
  # * <tt>:null_string</tt> -- The string that should be interpreted as NULL (in addition to \N)
  # * <tt>:enclosed_by</tt> -- The field enclosure
  def do_bulk_load_on_client(file, table_name, options={})
    q = build_copy_command(table_name, options, 'STDIN')
    buffer_size = options[:buffer_size] || DEFAULT_BUFFER_SIZE
    send_data_to_copy(file, @connection, q, buffer_size)
  end

  def build_copy_command(table_name, options, from)
    q = "COPY #{table_name} "
    q << "(#{options[:columns].join(',')}) " if options[:columns]
    q << "FROM #{from} "
    if options[:fields]
      q << "WITH "
      q << "DELIMITER '#{options[:fields][:delimited_by]}' " if options[:fields][:delimited_by]
      q << "NULL '#{options[:fields][:null_string]}'" if options[:fields][:null_string]
      if options[:fields][:enclosed_by] || options[:ignore] && options[:ignore] > 0
        q << "CSV "
        q << "HEADER " if options[:ignore] && options[:ignore] > 0
        q << "QUOTE '#{options[:fields][:enclosed_by]}' " if options[:fields][:enclosed_by]
      end
    end
    q
  end

  def send_data_to_copy(file, conn, q, buffer_size)
    conn.transaction do
      conn.exec(q)

      buf = ''
      io = File.open(file)

      begin
        while io.read(buffer_size, buf)
          until conn.put_copy_data(buf)
            sleep 0.1
          end
        end
      ensure
        conn.put_copy_end
        io.close
      end
    end
  end
end
