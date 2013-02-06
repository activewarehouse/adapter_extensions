module PostgresqlTests

  def test_support_select_into_table_should_return_false
    # TODO: mock connection adapter?
    assert connection.support_select_into_table?
  end

  def blank_slate!
    connection.truncate('truncate_test', 'RESTART IDENTITY')
    assert_equal "0", connection.select_value("SELECT count(*) FROM truncate_test")
  end

  def test_truncate_should_not_reset_identity_by_default
    blank_slate!

    connection.execute("insert into truncate_test (x) values ('a')")
    connection.truncate('truncate_test')

    connection.execute("insert into truncate_test (x) values ('a')")
    # in this case the id should not be reset to 1
    assert_equal "2", connection.select_value("SELECT id FROM truncate_test")
  end

  def test_truncate_should_reset_identity_if_requested
    blank_slate!

    connection.execute("insert into truncate_test (x) values ('a')")
    connection.truncate('truncate_test', 'RESTART IDENTITY')

    connection.execute("insert into truncate_test (x) values ('a')")
    # when using RESTART IDENTITY the id should be reset to 1
    assert_equal "1", connection.select_value("SELECT id FROM truncate_test")
  end

  def test_bulk_import_can_be_executed_by_the_db_server
    connection.truncate('people')
    assert_nothing_raised do
      options = {:fields => {:delimited_by => ','}}
      connection.bulk_load(File.join(File.dirname(__FILE__), 'people.csv'), 'people', options)
    end
    assert_equal 3, select_value("SELECT count(*) FROM people")
  end

  def test_bulk_import_can_be_executed_by_the_db_client
    connection.truncate('people')
    assert_nothing_raised do
      options = {:fields => {:delimited_by => ','}, :client => true}
      connection.bulk_load(File.join(File.dirname(__FILE__), 'people.csv'), 'people', options)
    end
    assert_equal 3, select_value("SELECT count(*) FROM people")
  end
end
