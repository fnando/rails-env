require 'rails-env/version'

module RailsEnv
  class Railtie < Rails::Railtie
    initializer 'rails-env' do
      Rails.env.extend(Extension)
    end
  end

  module Extension
    def on(*envs, &block)
      env_matched = envs.include?(:any) || envs.include?(Rails.env.to_sym)
      block.call(Rails.configuration) if env_matched
    end
  end
end
