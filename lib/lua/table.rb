# frozen_string_literal: true

require 'lua/table/version'

module Lua
  module Table
    class Error < StandardError; end
    # Your code goes here...
  end
end

require 'lua/table/parser'
require 'lua/table/transform'
