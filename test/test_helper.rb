ENV["RAILS_ENV"] = "test"

require "bundler/setup"
require "rails"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_controller/railtie"
require "active_job/railtie"
require "rails-env"

require "minitest/utils"
require "minitest/autorun"

class DummyApp < Rails::Application
  config.eager_load = false
end

Rails.application.initialize!
