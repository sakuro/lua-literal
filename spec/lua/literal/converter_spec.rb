# frozen_string_literal: true

require 'lua/literal/converter'

RSpec.describe Lua::Literal::Converter do
  let(:converter) { described_class.new }

  describe '#convert' do
    it 'parses empty literal "{}"' do
      expect(converter.convert('{}')).to eq({})
    end
  end
end
