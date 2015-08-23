require 'rails-env/version'

module RailsEnv
  class Railtie < Rails::Railtie
    initializer 'rails-env' do
      Rails.env.extend(Extension)
    end
  end

  def self.propagate_configuration!
    propagate(:action_mailer, '::ActionMailer::Base')
    propagate(:active_record, '::ActiveRecord::Base')
    propagate(:active_job, '::ActiveJob::Base')
    propagate(:time_zone, '::Time', :zone)
    propagate(:i18n, '::I18n')
  end

  def self.propagate(options_name, target_name, target_property = nil)
    return unless Object.const_defined?(target_name)
    return unless Rails.configuration.respond_to?(options_name)

    target = Object.const_get(target_name)
    options = Rails.configuration.public_send(options_name)

    if options.kind_of?(Enumerable)
      options.each do |key, value|
        target.public_send("#{key}=", value) if target.respond_to?("#{key}=")
      end
    else
      target.public_send("#{target_property}=", options)
    end
  end

  module Extension
    def on(*envs, &block)
      env_matched = envs.include?(:any) || envs.include?(Rails.env.to_sym)
      Rails.application.configure(&block) if env_matched
      RailsEnv.propagate_configuration!
    end
  end
end
