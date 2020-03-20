# frozen_string_literal: true

require 'lua/literal/parser'

RSpec.describe Lua::Literal::Parser do
  let(:parser) { described_class.new }

  describe '#parse' do
    it 'parses empty literal "{}"' do
      expect(parser.parse('{}')).to eq({})
    end
  end
end
