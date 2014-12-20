require 'spec_helper'

describe RailsEnv do
  it 'runs block when env matches' do
    block = proc {}
    expect(block).to receive(:call).with(Rails.configuration)
    Rails.env.on(:test, &block)
  end

  it 'skips block when env matches' do
    block = proc {}
    expect(block).not_to receive(:call)
    Rails.env.on(:production, &block)
  end
end
