def declare_gems(activerecord_version)
  source :rubygems

  gem 'activerecord', activerecord_version

  # use our own fork for bulk load support until issue fixed:
  # https://github.com/brianmario/mysql2/pull/242
  gem 'mysql2', :git => 'https://github.com/activewarehouse/mysql2.git'

  gem 'mysql'

  gem 'pg'
  gem 'activerecord-sqlserver-adapter'

  gem 'awesome_print'
  gem 'rake'
  gem 'flexmock'
end