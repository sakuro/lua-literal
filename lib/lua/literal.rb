# frozen_string_literal: true

require 'lua/literal/version'

module Lua
  module Literal
    class Error < StandardError; end
    # Your code goes here...
  end
end

require 'lua/literal/parser'
require 'lua/literal/transform'
