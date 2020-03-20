# frozen_string_literal: true

require 'lua/table/parser'

RSpec.describe Lua::Table::Parser do
  let(:parser) { described_class.new }

  describe '#parse' do
    it 'parses empty table "{}"' do
      expect(parser.parse('{}')).to eq({})
    end
    it 'parses field: exp = exp' do
      expect(parser.parse <<-LUA).to eq(fields: 'a' => 1)
        { a = 1 }
      LUA
    end
  end
end
