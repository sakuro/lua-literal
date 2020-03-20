# frozen_string_literal: true

RSpec.describe Lua::Table do
  it 'has a version number' do
    expect(Lua::Table::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to be_truthy
  end
end
