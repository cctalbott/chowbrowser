source 'http://rubygems.org'

gem 'rails', '~> 3.2.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sexp_processor', "~> 4.1.2"
gem 'execjs'
gem 'therubyracer', :platforms => :ruby

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem 'whenever', require: false
gem 'haml'
gem 'builder'
gem 'jbuilder'
gem 'delayed_job_active_record'
gem 'daemons'
#gem 'foreman'
#gem 'thin'
#gem 'rack-ssl', :require => 'rack/ssl'
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-openid'
gem 'cancan'
gem 'activemerchant'
#gem 'activemerchant', :git => "git://github.com/Shopify/active_merchant.git"
#gem 'activemerchant', :git => "git://github.com/cctalbott/active_merchant.git"
#gem 'activemerchant', :path => '~/Documents/github/active_merchant'
gem 'fancybox-rails'
gem 'dalli'
gem 'bcrypt-ruby'
gem 'prawn'
gem 'prawnto_2', :require => 'prawnto'
gem 'recaptcha'
gem 'twilio-ruby'
gem 'sitemap_generator'

# Use unicorn as the web server
gem 'unicorn'
#gem 'faye'
#gem 'private_pub'
gem 'private_pub', :git => 'git://github.com/cctalbott/private_pub.git'
gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'sqlite3'
  gem 'minitest'
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  gem "rb-readline"
end

group :production, :development, :staging do
  gem 'pg'
end

group :development, :test do
  gem 'ruby-prof'
  gem "rspec-rails"
end

group :development do
  gem 'hpricot'
  gem 'ruby_parser'
end
