require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env)

module Rsparly2013
  class Application < Rails::Application

    config.time_zone = 'UTC'
    config.i18n.default_locale = :en

    config.generators do |g|
      g.orm :active_record
      g.test_framework nil
      g.stylesheet_engine :sass
      g.template_engine :haml
      g.template_engine :coffee
    end

  end
end
