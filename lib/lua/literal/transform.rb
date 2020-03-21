# frozen_string_literal: true

require 'parslet'

module Lua
  module Literal
    class Transform < Parslet::Transform
      ESCAPE_SEQUENCES = {
        # rubocop:disable Style/StringHashKeys
        '\'' => '\'',
        '"' => '"',
        '\\' => '\\',
        'a' => "\a",
        'b' => "\b",
        'f' => "\f",
        'n' => "\n",
        'r' => "\r",
        't' => "\t",
        'v' => "\v"
        # rubocop:enable Style/StringHashKeys
      }.freeze
      private_constant :ESCAPE_SEQUENCES

      rule(integer: simple(:v)) {
        Integer(v)
      }

      rule(float: simple(:v)) {
        Float(v)
      }

      rule(name: simple(:v)) {
        v.to_sym
      }

      rule(raw_character: simple(:v)) {
        v.to_s
      }

      rule(escape_sequence: simple(:v)) {
        ESCAPE_SEQUENCES.fetch(v.to_s)
      }

      rule(hexadecimal_sequence: simple(:v)) {
        [v].pack('H2')
      }

      rule(decimal_sequence: simple(:v)) {
        [Integer(v)].pack('C')
      }

      rule(unicode_sequence: simple(:v)) {
        [v].pack('H*').force_encoding('UTF-16BE').encode('UTF-8')
      }

      rule(string: sequence(:vs)) {
        vs.join
      }

      rule('nil') {
        nil
      }

      rule('true') {
        true
      }

      rule('false') {
        false
      }

      rule(table: subtree(:fields)) {
        next {} if fields.nil?

        pairs = (fields.is_a?(Hash) ? [fields] : fields)
        indexed, kvs = pairs.partition {|pair| pair.key?(:indexed) }
        hash = kvs.inject({}) {|acc, pair| acc.merge(pair) }
        indexed.each.with_index(1).each {|v, i| hash[i] = v[:indexed] }
        hash
      }

      rule(key: subtree(:key), value: subtree(:value)) {
        {key => value}
      }
    end
  end
end
