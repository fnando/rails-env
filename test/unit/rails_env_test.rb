require "test_helper"

class Callable
  attr_accessor :configuration

  def to_proc
    callable = self

    lambda do |app|
      callable.configuration = config
    end
  end
end

class RailsEnvTest < Minitest::Test
  test "runs block when env matches" do
    block = Callable.new
    Rails.env.on(:test, &block)

    assert_equal Rails.configuration, block.configuration
  end

  test "matches against multiple envs" do
    block = Callable.new
    Rails.env.on(:development, :test, &block)

    assert_equal Rails.configuration, block.configuration
  end

  test "skips block when env differs" do
    block = Callable.new
    Rails.env.on(:production, &block)

    assert_nil block.configuration
  end

  test "runs on any environment" do
    block = Callable.new
    Rails.env.on(:any, &block)

    assert_equal Rails.configuration, block.configuration
  end
end
