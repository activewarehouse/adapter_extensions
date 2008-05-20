Gem::Specification.new do |s|
  s.authors = ["Anthony Eden"]
  s.bindir = "bin"
  s.rdoc_options = ["--exclude", "."]
  s.required_rubygems_version = ">= 0"
  s.has_rdoc = false
  s.specification_version = 2
  s.loaded = false
  s.email = "anthonyeden@gmail.com"
  s.version = "0.4.0"
  s.required_ruby_version = ">= 0"
  s.name = "adapter_extensions"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.1.0"
  s.homepage = "http://activewarehouse.rubyforge.org/adapter_extensions"
  s.platform = "ruby"
  s.summary = "Extensions to Rails ActiveRecord adapters."
  s.files = ["CHANGELOG",
    "README",
    "LICENSE",
    "Rakefile",
    "lib/adapter_extensions",
    "lib/adapter_extensions.rb",
    "lib/adapter_extensions/connection_adapters",
    "lib/adapter_extensions/version.rb",
    "lib/adapter_extensions/connection_adapters/abstract_adapter.rb",
    "lib/adapter_extensions/connection_adapters/mysql_adapter.rb",
    "lib/adapter_extensions/connection_adapters/postgresql_adapter.rb",
    "lib/adapter_extensions/connection_adapters/sqlserver_adapter.rb"]
  s.description = "Provides various extensions to the Rails ActiveRecord adapters."
  s.add_dependency "rake", ">= 0.7.1"
  s.add_dependency "activesupport", ">= 1.3.1"
  s.add_dependency "activerecord", ">= 1.14.4"
  s.add_dependency "fastercsv", ">= 1.0.0"
end