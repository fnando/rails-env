require 'rails-env/version'

module RailsEnv
  class Railtie < Rails::Railtie
    initializer 'rails-env' do
      Rails.env.extend(Extension)
    end
  end

  module Extension
    def on(env, &block)
      block.call(Rails.configuration) if Rails.env.to_s == env.to_s
    end
  end
end
