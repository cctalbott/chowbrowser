Takeoutapp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  # CONSTANTS
  BASE_URL = 'http://twilioapi:TwilioUserGoesHere@localhost:3000/twilio'
  FAYE_BASE_URL = 'http://localhost:9292'

  config.time_zone = "Central Time (US & Canada)"
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => 'smtp.gmail.com' }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # debug, info, warn, error, and fatal
  config.log_level = :debug

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    ::GATEWAY = ActiveMerchant::Billing::UsaEpayGateway.new(
      :login => "GatewayLoginGoesHere",
      :password => "GatewayPasswordGoesHere",
      :software_id => "GatewayIDGoesHere",
      :test => 'true',
      #:gateway => :sandbox
    )
  end
end
