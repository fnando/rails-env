# frozen_string_literal: true

require "rails-env/version"

module Rails
  class << self
    env_method = instance_method(:env=)
    remove_method(:env=)

    define_method :env= do |env|
      env_method.bind_call(self, env)
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
    propagate(:action_controller, "::ActionController::Base")
    propagate(:action_mailer, "::ActionMailer::Base")
    propagate(:action_view, "::ActionView::Base")
    propagate(:active_job, "::ActiveJob::Base")
    propagate(:active_record, "::ActiveRecord::Base")
    propagate(:time_zone, "::Time", :zone)
    propagate_hosts
    propagate_autoload_paths
    propagate_i18n
    propagate_cache_store
  end

  def self.propagate_cache_store
    Rails.cache = ActiveSupport::Cache.lookup_store(config.cache_store)
  end

  def self.propagate_hosts
    Rails.application.config.hosts = config.hosts
  end

  def self.propagate_i18n
    I18n.available_locales = (config.i18n.available_locales || [])
                             .compact
                             .map(&:to_sym)
                             .uniq

    if config.i18n.default_locale
      I18n.default_locale = config.i18n.default_locale
    end

    with_rails_constraint("< 7.0.0") do
      if config.i18n.respond_to?(:raise_on_missing_translations)
        ActionView::Base.raise_on_missing_translations =
          config.i18n.raise_on_missing_translations
      end
    end

    I18n.locale = config.i18n.locale if config.i18n.locale
    I18n.load_path += config.i18n.load_path if config.i18n.load_path
  end

  def self.propagate_autoload_paths
    all_autoload_paths = (
      config.autoload_paths +
      config.eager_load_paths +
      config.autoload_once_paths +
      ActiveSupport::Dependencies.autoload_paths
    ).uniq.freeze

    all_autoload_once_paths = (
      config.autoload_once_paths +
      ActiveSupport::Dependencies.autoload_once_paths
    ).uniq.freeze

    ActiveSupport::Dependencies.autoload_paths = all_autoload_paths
    ActiveSupport::Dependencies.autoload_once_paths = all_autoload_once_paths
  end

  def self.propagate(options_name, target_name, target_property = nil)
    return unless Object.const_defined?(target_name)
    return unless config.respond_to?(options_name)

    target = Object.const_get(target_name)
    options = config.public_send(options_name)

    if options.is_a?(Hash)
      options.each do |key, value|
        target.public_send("#{key}=", value) if target.respond_to?("#{key}=")
      end
    else
      target.public_send("#{target_property}=", options)
    end
  end

  def self.with_rails_constraint(constraint)
    Gem::Requirement
      .create(constraint)
      .satisfied_by?(Gem::Version.create(Rails::VERSION::STRING))
  end

  module Extension
    def on(*envs, &block)
      env_matched = envs.include?(:any) || envs.include?(Rails.env.to_sym)
      Rails.application.configure(&block) if env_matched
      RailsEnv.propagate_configuration!
    end
  end
end
