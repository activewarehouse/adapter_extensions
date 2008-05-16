require File.dirname(__FILE__) + '/test_helper'

class AbstractAdapterTest < Test::Unit::TestCase
  include ActiveRecord::ConnectionAdapters
  class MyAdapter < AbstractAdapter
    attr_accessor :query
    def initialize
      super(nil)
    end
    def tables
      ['people']
    end
    def execute(query)
      @query = query
    end
  end
  
  attr_accessor :adapter
  def setup
    @adapter = MyAdapter.new
  end
  
  def test_truncate
    table_name = 'foo'
    adapter.truncate(table_name)
    assert_equal "TRUNCATE TABLE #{table_name}", adapter.query
  end
  
  def test_support_select_into_table_should_return_false
    assert_equal false, adapter.support_select_into_table?
  end
  def test_add_select_into_table_should_raise_not_implemented_error
    assert_raises(NotImplementedError) { adapter.add_select_into_table(:new_table_name, :query) }
  end
  
  def test_bulk_load_with_non_existent_file
    file = 'f'
    assert_raises(ArgumentError, "#{file} does not exist") { adapter.bulk_load(file, :table_name)}
  end
  def test_bulk_load_with_non_existent_table
    filename = File.dirname(__FILE__) + '/integration/people.csv'
    #flexmock(File).should_receive(:exists?).and_return(true)
    table_name = 'foo'
    assert_raise(ArgumentError) do
      adapter.bulk_load(filename, table_name)
    end
  end
  
  def test_do_bulk_load_should_raise_not_implemented_error
    filename = File.dirname(__FILE__) + '/integration/people.csv'
    # I'd like to do the below but it doesn't seem to work the way I want
    #flexmock(File).should_receive(:exists?).and_return(true)
    table_name = 'people'
    assert_raise(NotImplementedError) do
      adapter.bulk_load(filename, table_name)
    end
  end

end