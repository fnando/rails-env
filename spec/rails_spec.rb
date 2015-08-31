require 'spec_helper'

describe RailsEnv, 'config propagation' do
  before do
    Rails.env.on(:test) do
      config.action_mailer.default_url_options = {host: 'localhost', port: 3000}
      config.action_mailer.raise_delivery_errors = true
      config.action_mailer.delivery_method = :letter_opener
      config.time_zone = 'America/Sao_Paulo'
      config.i18n.available_locales = ['pt-BR']
      config.i18n.default_locale = 'pt-BR'
    end
  end

  it 'assigns extended environment' do
    Rails.env = 'test'
    expect(Rails.env).to respond_to(:on)
  end

  it 'sets url options' do
    expect(ActionMailer::Base.default_url_options).to include(host: 'localhost', port: 3000)
  end

  it 'sets raise option' do
    expect(ActionMailer::Base.raise_delivery_errors).to be_truthy
  end

  it 'sets delivery method' do
    expect(ActionMailer::Base.delivery_method).to eq(:letter_opener)
  end

  it 'sets timezone' do
    expect(Time.zone.name).to eq('America/Sao_Paulo')
  end

  it 'sets locale' do
    expect(I18n.locale).to eq(:'pt-BR')
  end

  it 'sets available locales' do
    expect(I18n.available_locales).to eq([:'pt-BR'])
  end
end
