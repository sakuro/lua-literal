# frozen_string_literal: true

require 'lua/literal/converter'

RSpec.describe Lua::Literal::Converter do
  let(:converter) { described_class.new }

  describe '#convert' do
    it 'converts decimal integers' do
      expect(converter.convert('100')).to eq(100)
    end

    it 'converts negative decimal integers' do
      expect(converter.convert('-100')).to eq(-100)
    end

    # Though testing floating point values, we don't need to use `be_within` .. `of` matchers here
    # because we are testing whether string representations are converted to Ruby's literal numbers.
    it 'converts decimal floats without dot and with exponent denoted by "e"' do
      expect(converter.convert('10e1')).to eq(10e1)
    end

    it 'converts negative decimal floats without dot and with exponent denoted by "e"' do
      expect(converter.convert('-10e1')).to eq(-10e1)
    end

    it 'converts decimal floats without dot with exponent denoted by "E"' do
      expect(converter.convert('10E1')).to eq(10e1)
    end

    it 'converts negative decimal floats without dot with exponent denoted by "E"' do
      expect(converter.convert('-10E1')).to eq(-10e1)
    end

    it 'converts decimal floats with dot' do
      expect(converter.convert('3.1416')).to eq(3.1416)
    end

    it 'converts negative decimal floats with dot' do
      expect(converter.convert('-3.1416')).to eq(-3.1416)
    end

    it 'converts decimal floats with dot and exponent denoted by "e"' do
      expect(converter.convert('314.16e-2')).to eq(3.1416)
    end

    it 'converts negative decimal floats with dot and exponent denoted by "e"' do
      expect(converter.convert('-314.16e-2')).to eq(-3.1416)
    end

    it 'converts decimal floats with dot and exponent denoted by "E"' do
      expect(converter.convert('314.16E-2')).to eq(3.1416)
    end

    it 'converts negative decimal floats with dot and exponent denoted by "E"' do
      expect(converter.convert('-314.16E-2')).to eq(-3.1416)
    end

    it 'converts `true` to `true`' do
      expect(converter.convert('true')).to eq(true)
    end

    it 'converts `false` to `false`' do
      expect(converter.convert('false')).to eq(false)
    end

    it 'converts `nil` to `nil`' do
      expect(converter.convert('nil')).to eq(nil)
    end

    # rubocop:disable Style/RedundantPercentQ
    it 'converts strings surounded by single quotes' do
      expect(converter.convert(%q|'foobar'|)).to eq('foobar')
    end

    it 'converts strings surounded by double quotes' do
      expect(converter.convert(%q|"foobar"|)).to eq('foobar')
    end

    it 'converts C-like escape sequences in strings' do
      expect(converter.convert(%q|'foo\\a\\b\\f\\n\\r\\t\\vbar'|)).to eq("foo\a\b\f\n\r\t\vbar")
    end

    it 'converts decimal escape sequences in strings' do
      expect(converter.convert(%q|'fo\\111\\098ar'|)).to eq('foobar')
    end

    it 'converts hexadecimal escape sequences in strings' do
      expect(converter.convert(%q|'fo\\x6f\\X62ar'|)).to eq('foobar')
    end

    it 'converts Unicode escape sequences in strings' do
      expect(converter.convert(%q|'fo\\u{006f}\\U{0062}ar'|)).to eq('foobar')
    end
    # rubocop:enable Style/RedundantPercentQ

    it 'converts empty table literal "{}"' do
      expect(converter.convert('{}')).to eq({})
    end

    it 'converts keys in brackets' do
      expect(converter.convert('{["a"] = 0, [3.14] = "pi"}')).to eq('a' => 0, 3.14 => 'pi') # rubocop:disable Style/StringHashKeys
    end

    it 'converts name keys to `Symbol`s"' do
      expect(converter.convert('{a = 1, b = 2, c = {d = 3}}')).to eq({a: 1, b: 2, c: {d: 3}})
    end

    it 'converts value only fields to integer indexed values' do
      expect(converter.convert('{"a", "b", {c = 10}}')).to eq(1 => 'a', 2 => 'b', 3 => {c: 10})
    end
  end
end
