require File.dirname(__FILE__) + '/../test_helper'

# Integration tests
class AdapterTest < Test::Unit::TestCase
  
  require File.dirname(__FILE__) + "/#{ENV['DB']}_tests"
  include "#{ENV['DB'].capitalize}Tests".constantize

  def test_add_select_into_table
    new_table_name = 'new_people'
    sql_query = 'select * from people'
    assert_equal "CREATE TABLE #{new_table_name} #{sql_query}",
      connection.add_select_into_table(new_table_name, sql_query)
  end

  def test_truncate
    connection.delete("delete from truncate_test")
    %w|a b c|.each do |value|
      connection.execute("insert into truncate_test (x) values ('#{value}')")
    end
    
    assert_equal "3", connection.select_value("SELECT count(*) FROM truncate_test")
    assert_nothing_raised { connection.truncate('truncate_test') }
    assert_equal "0", connection.select_value("SELECT count(*) FROM truncate_test")
  end
   
  def test_bulk_load
    connection.truncate('people')
    assert_equal "0", connection.select_value("SELECT count(*) FROM people")
    assert_nothing_raised do
      connection.bulk_load(File.join(File.dirname(__FILE__), 'people.txt'), 'people')
    end
    assert_equal "3", connection.select_value("SELECT count(*) FROM people")
  end
   
  def test_bulk_load_csv
    connection.truncate('people')
    assert_nothing_raised do
      options = {:fields => {:delimited_by => ','}}
      connection.bulk_load(File.join(File.dirname(__FILE__), 'people.csv'), 'people', options)
    end
    assert_equal "3", connection.select_value("SELECT count(*) FROM people")
  end
  
  def test_bulk_load_with_enclosed_by
    connection.truncate('people')
    assert_nothing_raised do
      options = {:fields => {:delimited_by => ',', :enclosed_by => '"'}}
      connection.bulk_load(File.join(File.dirname(__FILE__), 'people.csv'), 'people', options)
    end
    assert_equal "3", connection.select_value("SELECT count(*) FROM people")
  end
  
  def test_bulk_load_with_empty_file
    connection.truncate('people')
    assert_nothing_raised do
      connection.bulk_load(File.dirname(__FILE__) + '/empty.csv', 'people')
    end
  end
  
  def test_add_select_into_table
    sql_query = 'SELECT foo FROM bar'
    new_table_name = 'new_table'

    case ENV['DB']
    when 'sqlserver', 'postgresql'
      assert_equal 'SELECT foo INTO new_table FROM bar',
      connection.add_select_into_table(new_table_name, sql_query)
    when 'mysql'
      assert_equal 'CREATE TABLE new_table SELECT foo FROM bar',
      connection.add_select_into_table(new_table_name, sql_query)
    else
      puts "Don't know how to add select into table for #{ENV['DB']}"
    end
  end
  
  def test_copy_table_should_copy_structure_and_data
    table_name = 'people'
    dest_table_name = "temp_#{table_name}"
    
    begin connection.drop_table(dest_table_name); rescue; end;
    connection.execute("DELETE FROM #{table_name}")
    
    options = {:fields => {:delimited_by => ',', :enclosed_by => '"'}}
    connection.bulk_load(File.join(File.dirname(__FILE__), 'people.csv'), 'people', options)
    connection.copy_table(table_name, dest_table_name)
    assert_equal 3, connection.select_value("SELECT count(*) FROM #{dest_table_name}").to_i
  end
  
  private
  def connection
    ActiveRecord::Base.connection
  end
end