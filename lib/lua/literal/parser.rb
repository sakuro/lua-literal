# frozen_string_literal: true

require 'parslet'

module Lua
  module Literal
    # https://www.lua.org/manual/5.3/manual.html
    class Parser < Parslet::Parser # rubocop:disable Metrics/ClassLength
      root :exp

      # table_constructor ::= '{' [fieldlist] '}'
      rule(:table_constructor) {
        (str('{') >> space? >> fieldlist.maybe.as(:table) >> space? >> str('}'))
      }

      # fieldlist ::= field {fieldsep field} [fieldsep]
      rule(:fieldlist) {
        field >> space? >> (fieldsep >> space? >> field).repeat >> space? >> fieldsep.maybe
      }

      # field ::= '[' exp ']' '=' exp | Name '=' exp | exp
      rule(:field) {
        (str('[') >> space? >> exp.as(:key) >> space? >> str(']') >> space? >> str('=') >> space? >> exp.as(:value)) |
        (name.as(:key) >> space? >> str('=') >> space? >> exp.as(:value)) |
        exp.as(:indexed)
      }

      # fieldsep ::= ',' | ';'
      rule(:fieldsep) {
        str(',') | str(';')
      }

      # -- exp ::= prefixexp
      # exp ::= nil | false | true
      # exp ::= Numeral
      # exp ::= LiteralString
      # -- exp ::= functiondef
      # exp ::= table_constructor
      # -- exp ::= '...'
      # -- exp ::= exp binop exp
      # -- exp ::= unop exp
      # -- prefixexp ::= var | functioncall | '(' exp ')'
      rule(:exp) {
        space? >>
        (
          table_constructor |
          string_concatenation |
          scalar
        ) >> space?
      }

      rule(:scalar) {
        literal_nil |
        literal_false |
        literal_true |
        numeral |
        literal_string
      }

      rule(:literal_nil) {
        str('nil')
      }

      rule(:literal_false) {
        str('false')
      }

      rule(:literal_true) {
        str('true')
      }

      # numeral
      rule(:numeral) {
        decimal_numeral
        # TODO: hexadecimal_numeral
      }

      rule(:decimal_numeral) {
        (str('-').maybe >> decimal_float).as(:float) |
        (str('-').maybe >> decimal_integer).as(:integer)
      }

      rule(:decimal_figure) {
        match('[0-9]')
      }

      rule(:decimal_integer) {
        decimal_figure.repeat(1)
      }

      rule(:decimal_integer?) {
        decimal_figure.repeat(0)
      }

      rule(:decimal_float) {
        decimal_integer >> str('.') >> decimal_integer? >> decimal_exponent.maybe |
        decimal_integer? >> str('.') >> decimal_integer >> decimal_exponent.maybe |
        decimal_integer >> decimal_exponent
      }

      rule(:decimal_exponent) {
        match('[eE]') >> match('[-+]').maybe >> decimal_integer
      }

      # literal_string
      rule(:literal_string) {
        short_literal_string
        # TODO: long_literal_string
      }

      rule(:short_literal_string) {
        q >> character.repeat.as(:string) >> q |
        qq >> character.repeat.as(:string) >> qq
      }

      rule(:q) {
        str('\'')
      }

      rule(:qq) {
        str('"')
      }

      rule(:esc) {
        str('\\')
      }

      rule(:character) {
        escape_sequence |
        hexadecimal_sequence |
        decimal_sequence |
        unicode_sequence |
        raw_character
      }

      rule(:escape_sequence) {
        esc >> (q | qq | esc | match('[abfnrtv]')).as(:escape_sequence)
        # TODO: \z
      }

      rule(:hexadecimal_sequence) {
        esc >> match('[xX]') >> hexadecimal_digit.repeat(2, 2).as(:hexadecimal_sequence)
      }

      rule(:decimal_sequence) {
        esc >> decimal_digit.repeat(1, 3).as(:decimal_sequence)
      }

      rule(:unicode_sequence) {
        esc >> match('[uU]') >> str('{') >> hexadecimal_digit.repeat(1).as(:unicode_sequence) >> str('}')
      }

      rule(:raw_character) {
        match('[^\\\'"]').as(:raw_character)
      }

      rule(:hexadecimal_digit) {
        match('[0-9a-fA-F]')
      }

      rule(:decimal_digit) {
        match('[0-9]')
      }

      rule(:string_concatenation) {
        (scalar.as(:lhs) >> space? >> str('..') >> space? >> scalar.as(:rhs)).as(:string_concatenation)
      }

      rule(:name) {
        (match('[A-Za-z_]') >> match('[A-Za-z_0-9]').repeat).as(:name)
      }

      rule(:space) {
        match('\s')
      }

      rule(:comment) {
        short_comment
        # TODO: long_comment
      }

      rule(:short_comment) {
        str('--') >> match('[^\n]').repeat >> str("\n").maybe
      }

      rule(:space?) {
        (space | comment).repeat
      }

      # Parses the given argument as a Lua literal expression
      #
      # See {file:README.md} for supported syntax.
      # @param [String, Parslet::Source] lua_literal Lua literal expression
      # @return [Hash, Array, Parslet::Slice] PORO (Plain old Ruby object) result tree
      # @see {::Parslet::Parser#parse}
      def parse(lua_literal)
        super(lua_literal)
      rescue Parslet::ParseFailed
        raise Lua::Literal::ParseError
      end
    end
  end
end
