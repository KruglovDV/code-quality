# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require './app/middlewares/set_locale_middleware'

Bundler.require(*Rails.groups)

module GithubQuality
  class Application < Rails::Application
    config.load_defaults 6.1

    config.i18n.default_locale = :ru
    config.middleware.use SetLocaleMiddleware
    routes.default_url_options = { host: ENV.fetch('BASE_URL') }
  end
end
