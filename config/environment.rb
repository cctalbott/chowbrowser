# Load the rails application
require File.expand_path('../application', __FILE__)

Haml::Template.options[:ugly] = true

# Initialize the rails application
Takeoutapp::Application.initialize!
