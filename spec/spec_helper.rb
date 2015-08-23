ENV['RAILS_ENV'] = 'test'

require 'bundler/setup'
require 'rails'
require 'action_mailer/railtie'
require 'rails-env'

class DummyApp < Rails::Application
  config.eager_load = false
end

Rails.application.initialize!
