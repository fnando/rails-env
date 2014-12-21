require 'rails-env/version'

module RailsEnv
  class Railtie < Rails::Railtie
    initializer 'rails-env' do
      Rails.env.extend(Extension)
    end
  end

  module Extension
    def on(*envs, &block)
      block.call(Rails.configuration) if envs.include?(Rails.env.to_sym)
    end
  end
end
