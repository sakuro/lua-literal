# frozen_string_literal: true

RSpec.describe Lua::Table do
  it 'has a version number' do
    expect(Lua::Table::VERSION).not_to be nil
  end
end
