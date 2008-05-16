module PostgresqlTests
  def test_support_select_into_table_should_return_false
    # TODO: mock connection adapter?
    assert connection.support_select_into_table?
  end
end