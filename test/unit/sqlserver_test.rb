require File.dirname(__FILE__) + '/../test_helper'

class SqlServerTest < Test::Unit::TestCase

  def adapter
    @adapter ||= ActiveRecord::ConnectionAdapters::SQLServerAdapter.new(nil)
  end

  def prepare_mocks
    flexmock(File).should_receive(:exist?).with("the_file").and_return(true).once
    flexmock(adapter).should_receive(:tables).and_return(['the_table']).once
    flexmock(ActiveRecord::Base).should_receive(:configurations).and_return(
      'fake_env' => {
        'database' => 'the_database',
        'host' => 'the_host',
        'username' => 'the_username',
        'password' => 'the_password'
      }
    )
  end

  def bulk_load(options)
    options = {:env => 'fake_env'}.merge(options)
    adapter.bulk_load("the_file", "the_table", options)
  end

  def assert_bulk_command(pattern, options = {})
    prepare_mocks
    command_result = options.delete(:command_successful)
    command_result = true if command_result.nil?
    flexmock(Kernel).should_receive(:system).with(pattern).and_return(command_result)
    bulk_load(options)
  end

  def test_freebcp_by_default
    assert_bulk_command(/^freebcp/)
  end

  def test_custom_bin_can_be_specified
    assert_bulk_command(/^bcp /, :bin => 'bcp')
  end

  def test_command
    assert_bulk_command(/ "the_database\.dbo\.the_table" in "the_file" /)
  end

  def test_host
    assert_bulk_command(/ \-S "the_host" /)
  end

  def test_user
    assert_bulk_command(/ \-U "the_username" /)
  end

  def test_password
    assert_bulk_command(/ \-P "the_password" /)
  end

  def test_character_format
    assert_bulk_command(/ \-c /)
  end

  def test_delimited_by
    assert_bulk_command(/ \-t "," /, :fields => { :delimited_by => ',' })
  end

  def test_max_errors
    assert_bulk_command(/ \-m 1/, :max_errors => 1)
  end

  def test_failed_command_must_raise
    exception = assert_raise(RuntimeError) do
      assert_bulk_command(//, :command_successful => false)
    end
    assert_equal "bulk load failed!", exception.message
  end

  def test_unsupported_columns_option
    assert_raise(NotImplementedError) do
      assert_bulk_command(//, :columns => %w(id first_name last_name))
    end
  end

end