Gem::Specification.new do |s|
  s.name = %q{adapter_extensions}
  s.version = "0.4.0.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anthony Eden"]
  s.date = %q{2008-05-22}
  s.description = %q{Provides various extensions to the Rails ActiveRecord adapters.}
  s.email = %q{anthonyeden@gmail.com}
  s.files = ["CHANGELOG", "README", "LICENSE", "Rakefile", "lib/adapter_extensions", "lib/adapter_extensions.rb", "lib/adapter_extensions/connection_adapters", "lib/adapter_extensions/version.rb", "lib/adapter_extensions/connection_adapters/abstract_adapter.rb", "lib/adapter_extensions/connection_adapters/mysql_adapter.rb", "lib/adapter_extensions/connection_adapters/postgresql_adapter.rb", "lib/adapter_extensions/connection_adapters/sqlserver_adapter.rb"]
  s.homepage = %q{http://activewarehouse.rubyforge.org/adapter_extensions}
  s.rdoc_options = ["--exclude", "."]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{activewarehouse}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Extensions to Rails ActiveRecord adapters.}

  s.add_dependency(%q<rake>, [">= 0.7.1"])
  s.add_dependency(%q<activesupport>, [">= 1.3.1"])
  s.add_dependency(%q<activerecord>, [">= 1.14.4"])
  s.add_dependency(%q<fastercsv>, [">= 1.0.0"])
end
