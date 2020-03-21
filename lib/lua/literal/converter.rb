# frozen_string_literal: true

require 'lua/literal/parser'
require 'lua/literal/transform'

module Lua
  module Literal
    class Converter
      def initialize
        @parser = Lua::Literal::Parser.new
        @transform = Lua::Literal::Transform.new
      end

      def convert(lua_literal)
        @transform.apply(@parser.parse(lua_literal))
      end
    end
  end
end
