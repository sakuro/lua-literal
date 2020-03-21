# frozen_string_literal: true

require 'lua/literal/version'
require 'lua/literal/converter'
require 'lua/literal/parser'
require 'lua/literal/transform'

module Lua
  module Literal
    class Error < StandardError; end
  end
end
