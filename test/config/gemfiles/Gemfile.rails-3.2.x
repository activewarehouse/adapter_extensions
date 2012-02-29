source :rubygems

gem 'activerecord', '3.2.1'

# use our own fork for bulk load support until issue fixed:
# https://github.com/brianmario/mysql2/pull/242
gem 'mysql2', :git => 'git://github.com/activewarehouse/mysql2.git'

gem 'mysql'

gem 'pg'
gem 'activerecord-sqlserver-adapter'

gem 'awesome_print'
gem 'rake'
gem 'flexmock'