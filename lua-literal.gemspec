# frozen_string_literal: true

require_relative 'lib/lua/literal/version'

Gem::Specification.new do |spec|
  spec.name          = 'lua-literal'
  spec.version       = Lua::Literal::VERSION
  spec.authors       = ['OZAWA Sakuro']
  spec.email         = ['sakuro@2238.club']

  spec.summary       = 'Parser for Lua literals'
  spec.description   = <<~DESCRIPTION
    Lua-literal provides parser for the literals of Lua language.
  DESCRIPTION
  spec.homepage      = 'https://github.com/sakuro/lua-literal'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/sakuro/lua-literal.git'
  spec.metadata['changelog_uri'] = 'https://github.com/sakuro/lua-literal/blob/master/CHANGES.md'

  spec.files = Dir.chdir(__dir__) { %x(git ls-files -z).split("\x0").grep_v(/^spec\//) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.80.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.38.1'

  spec.add_runtime_dependency 'parslet', '~> 2.0.0'
end
