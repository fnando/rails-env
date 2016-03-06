require "rails-env/version"

module Rails
  class << self
    env_method = instance_method(:env=)

    define_method :env= do |env|
      env_method.bind(self).call(env)
      Rails.env.extend(RailsEnv::Extension)
    end
  end
end

module RailsEnv
  class Railtie < Rails::Railtie
    initializer "rails-env" do
      Rails.env.extend(Extension)
    end
  end

  def self.config
    Rails.configuration
  end

  def self.propagate_configuration!
    propagate(:action_mailer, "::ActionMailer::Base")
    propagate(:active_record, "::ActiveRecord::Base")
    propagate(:active_job, "::ActiveJob::Base")
    propagate(:action_controller, "::ActionController::Base")
    propagate(:time_zone, "::Time", :zone)
    propagate_i18n
  end

  def self.propagate_i18n
    I18n.available_locales = (config.i18n.available_locales || [])
                              .compact
                              .map(&:to_sym)
                              .uniq
    I18n.default_locale = config.i18n.default_locale if config.i18n.default_locale
    I18n.locale = config.i18n.locale if config.i18n.locale
    I18n.load_path += config.i18n.load_path if config.i18n.load_path
  end

  def self.propagate(options_name, target_name, target_property = nil)
    return unless Object.const_defined?(target_name)
    return unless config.respond_to?(options_name)

    target = Object.const_get(target_name)
    options = config.public_send(options_name)

    if options.is_a?(Enumerable)
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
