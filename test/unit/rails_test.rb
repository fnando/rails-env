# frozen_string_literal: true

require "test_helper"

class ConfigPropagationTest < Minitest::Test
  setup do
    Rails.env.on(:test) do
      config.action_mailer.default_url_options = {host: "localhost", port: 3000}
      config.action_mailer.raise_delivery_errors = true
      config.action_mailer.delivery_method = :letter_opener
      config.time_zone = "America/Sao_Paulo"
      config.i18n.available_locales = ["pt-BR"]
      config.i18n.default_locale = "pt-BR"

      if config.i18n.respond_to?(:raise_on_missing_translations)
        config.i18n.raise_on_missing_translations = true
      else
        config.action_view.raise_on_missing_translations = true
      end

      config.active_job.queue_adapter = :test
      config.hosts = %w[example.com]

      config.autoload_paths += ["#{__dir__}/al"]
      config.autoload_once_paths += ["#{__dir__}/alo"]
      config.eager_load_paths += ["#{__dir__}/el"]

      config.cache_store = :memory_store
    end
  end

  test "assigns extended environment" do
    Rails.env = "test"
    assert Rails.env.respond_to?(:on)
  end

  test "sets url options" do
    assert_equal "localhost", ActionMailer::Base.default_url_options[:host]
    assert_equal 3000, ActionMailer::Base.default_url_options[:port]
  end

  test "sets raise option" do
    assert ActionMailer::Base.raise_delivery_errors
  end

  test "sets delivery method" do
    assert_equal :letter_opener, ActionMailer::Base.delivery_method
  end

  test "sets timezone" do
    assert_equal "America/Sao_Paulo", Time.zone.name
  end

  test "sets locale" do
    assert_equal :"pt-BR", I18n.locale
  end

  test "sets available locales" do
    assert_equal [:"pt-BR"], I18n.available_locales
  end

  RailsEnv.with_rails_constraint("< 7.0.0") do
    test "sets raise on missing translations" do
      assert ActionView::Base.raise_on_missing_translations
    end
  end

  test "sets queue adapter" do
    assert_kind_of ActiveJob::QueueAdapters::TestAdapter,
                   ActiveJob::Base.queue_adapter
  end

  test "sets autoload_paths" do
    assert ActiveSupport::Dependencies.autoload_paths.include?("#{__dir__}/al")
    assert ActiveSupport::Dependencies.autoload_paths.include?("#{__dir__}/el")
    assert ActiveSupport::Dependencies.autoload_paths.include?("#{__dir__}/alo")
  end

  test "sets autoload_once_paths" do
    assert ActiveSupport::Dependencies.autoload_once_paths.include?(
      "#{__dir__}/alo"
    )
  end

  test "sets cache store" do
    assert_kind_of ActiveSupport::Cache::MemoryStore, Rails.cache
  end

  test "sets hosts" do
    assert_equal %w[example.com], Rails.application.config.hosts
  end
end
