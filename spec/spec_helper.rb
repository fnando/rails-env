ENV['RAILS_ENV'] = 'test'

require 'bundler/setup'
require 'rails/all'
require 'rails-env'

class DummyApp < Rails::Application
  config.eager_load = false
end

Rails.application.initialize!
