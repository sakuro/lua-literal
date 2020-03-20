# frozen_string_literal: true

RSpec.describe Lua::Literal do
  it 'has a version number' do
    expect(Lua::Literal::VERSION).not_to be nil
  end
end
