# Lua::Literal

Lua::Literal provides a class which converts literals written in [Lua](https://www.lua.org/)'s syntax to Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lua-literal'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install lua-literal

## Usage

```ruby
require 'lua/literal/converter'

converter = Lua::Literal::Converter.new
converter.convert('{a=1, b=2, ["c"]={d=3}, {e=4}, {f=5}}')
#=> {:a=>1, :b=>2, "c"=>{:d=>3}, 1=>{:e=>4}, 2=>{:f=>5}}
```

## Supported literals

### `true`, `false` and `nil`

These are converted to Ruby's `true`, `false` and `nil` respectively.

### Numerals

Only decimal numerals are recognized and converted Ruby's `Integer` or `Float`.
As in Lua, unary plus operator is not allowed.

### Strings

Only Short string literals are converted.

Following escape sequences are supported.

* C-like escape sequences
* Hexadecimal and decimal escape sequences
* Unicode escape sequences

### Tables

Lua's tables are converted to Ruby's `Hash`.

* Expression only fields, which are indexed by integer keys in Lua, are also stored as key-value pairs.
* Name only keys (not in `[...]`) are converted to Ruby's `Symbol`s.

### Comments

Short comments are recognized and removed.

## Unsupported literals

* Hexadecimal numerals.
* Long string literals (denoted by `[[`, `[=[` and such)
* Long comments.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sakuro/lua-literal.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
