source 'http://rubygems.org'
gem 'rake', '~> 0.8.7'

gem 'rails', '3.0.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem 'mini_fb'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

group :production do
  gem 'mysql2', '0.2.8'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:

group :test do
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'spork'
  gem 'launchy'
end
