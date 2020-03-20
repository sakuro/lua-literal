# frozen_string_literal: true

require 'parslet'

module Lua
  module Table
    # https://www.lua.org/manual/5.3/manual.html
    class Parser < Parslet::Parser # rubocop:disable Metrics/ClassLength
      root :table_constructor

      # table_constructor ::= '{' [fieldlist] '}'
      rule(:table_constructor) {
        (space? >> str('{') >> space? >> fieldlist.maybe.as(:fields) >> space? >> str('}') >> space?).as(:table)
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
      # exp ::= tableconstructor
      # -- exp ::= '...'
      # -- exp ::= exp binop exp
      # -- exp ::= unop exp
      # -- prefixexp ::= var | functioncall | '(' exp ')'
      rule(:exp) {
        table_constructor |
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
        str('-').maybe >> decimal_numeral
        # TODO: hexadecimal_numeral
      }

      rule(:decimal_numeral) {
        decimal_integer.as(:integer) | decimal_float.as(:float)
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
        decimal_integer? >> str('.') >> decimal_integer >> decimal_exponent.maybe
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
        raw_character |
        escape_sequence |
        hexadecimal_sequence |
        decimal_sequence |
        unicode_sequence
      }

      rule(:escape_sequence) {
        esc >> (q | qq | esc | match('[abfnrtv]'))
        # TODO: \z
      }

      rule(:hexadecimal_sequence) {
        esc >> match('[xX]') >> hexadecimal_digit.repeat(2, 2)
      }

      rule(:decimal_sequence) {
        esc >> decimal_digit.repeat(3, 3)
      }

      rule(:unicode_sequence) {
        esc >> match('[uU]') >> (str('{') >> hexadecimal_digit.repeat(1) >> str('}') | hexadecimal_digit.repeat(1))
      }

      rule(:raw_character) {
        match('[^\\\'"]')
      }

      rule(:hexadecimal_digit) {
        match('[0-9a-fA-F]')
      }

      rule(:decimal_digit) {
        match('[0-9]')
      }

      rule(:name) {
        match('[A-Za-z_]') >> match('[A-Za-z_0-9]').repeat
      }

      rule(:space) {
        match('\s')
      }

      rule(:comment) {
        short_comment
        # TODO: long_comment
      }

      rule(:short_comment) {
        str('--') >> match('[^\n]').repeat >> str("\n")
      }

      rule(:space?) {
        (space | comment).repeat
      }
    end
  end
end
