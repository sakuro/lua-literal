require_relative 'lib/lua/table/version'

Gem::Specification.new do |spec|
  spec.name          = "lua-table"
  spec.version       = Lua::Table::VERSION
  spec.authors       = ["OZAWA Sakuro"]
  spec.email         = ["sakuro@2238.club"]

  spec.summary       = %q{Handle Lua tables.}
  spec.description   = %q{Lua-table provides parser for the _table_ data structure of Lua.}
  spec.homepage      = "https://github.com/sakuro/lua-table"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sakuro/lua-table.git"
  spec.metadata["changelog_uri"] = "https://github.com/sakuro/lua-table/blob/master/CHANGES.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
end
