This library provides extensions to Rails' ActiveRecord adapters.

As of version 0.9.5, adapter_extensions has dependencies on ActiveSupport and ActiveRecord 2.1.x or higher.

### How to test

Currently tested on MySQL and Postgres.

#### Testing on MySQL

see `test/connection/mysql/connection.rb` and tweek if needed, then:

    mysql -u root -p -e "create database adapter_extensions_unittest"
    rake test
    
One test should fail with 'known issue with MySQL' (see commit 75da4b08).

#### Testing on Postgresql

see `test/connection/postgresql/connection.rb` and tweek if needed, then:

    createdb adapter_extensions_unittest
    rake test DB=postgresql
