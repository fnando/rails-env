require "spec_helper"

class Callable
  attr_accessor :configuration

  def to_proc
    callable = self

    lambda do |app|
      callable.configuration = config
    end
  end
end

describe RailsEnv do
  it "runs block when env matches" do
    block = Callable.new
    Rails.env.on(:test, &block)

    expect(block.configuration).to eq(Rails.configuration)
  end

  it "matches against multiple envs" do
    block = Callable.new
    Rails.env.on(:development, :test, &block)

    expect(block.configuration).to eq(Rails.configuration)
  end

  it "skips block when env differs" do
    block = Callable.new
    Rails.env.on(:production, &block)

    expect(block.configuration).to be_nil
  end

  it "runs on any environment" do
    block = Callable.new
    Rails.env.on(:any, &block)

    expect(block.configuration).to eq(Rails.configuration)
  end
end
