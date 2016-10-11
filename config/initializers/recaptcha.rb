Recaptcha.configure do |config|
  if ENV["RAILS_ENV"] == "development"
    config.public_key  = '6Lcq980SAAAAAK-aY3VHcojtOdEePYXzz2UyrxLN'
    config.private_key = '6Lcq980SAAAAACY215UrCcw3PGb7FGzMHMbJ2T6L'
  elsif ENV["RAILS_ENV"] == "production"
    config.public_key  = '6Lde980SAAAAANf_fTN1OeePmZuE-maNxtvDVu3Q'
    config.private_key = '6Lde980SAAAAADgl4hCktn3epsak7pp0P08DxpZ8'
  else
    config.public_key  = '6Lcq980SAAAAAK-aY3VHcojtOdEePYXzz2UyrxLN'
    config.private_key = '6Lcq980SAAAAACY215UrCcw3PGb7FGzMHMbJ2T6L'
  end
end
