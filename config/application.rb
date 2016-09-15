require File.expand_path('../boot', __FILE__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ftms
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.time_zone = "Hanoi"
    config.i18n.default_locale = :en
    I18n.config.enforce_available_locales = true
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**",
      "*.{rb,yml}")]

    config.i18n.available_locales = [:en, :ja]
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.middleware.use I18n::JS::Middleware
    config.action_controller.permit_all_parameters = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: "587",
      domain: "localhost",
      user_name: ENV["GMAIL_USERNAME"],
      password: ENV["GMAIL_PASSWORD"],
      authentication: :plain,
      enable_starttls_auto: true
    }
    config.action_mailer.perform_deliveries = true
    Rails.application.config.middleware.use ExceptionNotification::Rack,
      email: {
        verbose_subject: false,
        normalize_subject: true,
        email_prefix: "[FTMS]_System-ERROR ",
        sender_address: ENV["GMAIL_USERNAME"],
        exception_recipients: %w{ENV["GMAIL_USERNAME"]}
      }
  end
end
