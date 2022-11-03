source 'https://rubygems.org'
ruby "3.1.2"

# Migrating Sessions
gem 'activerecord-session_store'

# Items Sorting and Reordering
gem 'acts_as_list'

# Saas Mixin
gem 'bourbon'

# WYSIWYG Editor
gem 'ckeditor', '4.2.4'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# User authentication
gem 'devise', '~> 4.8', '>= 4.8.1'

# Search Engine friendly URL's
gem 'friendly_id', '~> 5.0.0'

# Geo Location Gem
gem 'geocoder'

# Haml file support
gem 'haml'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Call function on both page load and page change, works with turbolinks
gem 'jquery-turbolinks'

# Provide Jquery UI functionality
gem 'jquery-ui-rails'

# Pagination Gem
gem 'kaminari'

# Send email directly
gem 'mail_form'

# Add meta tags with ease
gem 'meta-tags', require: 'meta_tags'

# Mobile Detection and render proper mobile view
gem 'mobile-fu'

# Nokogiri for XML parsing
gem 'nokogiri'

# Omniauth facebook support
gem 'omniauth-facebook'

# Omniauth linkedin support
gem 'omniauth-linkedin'

# Omniauth twitter support
gem 'omniauth-twitter'

# Image upload gem used by ckeditor
gem 'paperclip'

# Postgres database
gem 'pg'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.2'

# ReCaptcha
gem "recaptcha", '0.4.0', require: "recaptcha/rails"

# Adding redis
gem 'redis'

# Use ImageMagick
gem 'rmagick'

# Use SCSS for stylesheets
gem 'sass-rails'

# Simple form
gem 'simple_form'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'tzinfo-data'

# Unicorm server instead of default rails server
# gem 'unicorn'
platforms :ruby do
  gem 'unicorn'
end
platforms :mswin do
  gem 'thin'
end


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  # Will create comments in top of model with all attributes.
  gem 'annotate'

  # Display better errors in browser
  gem 'better_errors'

  # Query alert gem. It alerts N + 1 queriey and so on
  gem 'bullet'

  # Run tests automatically via guard
  gem 'guard-minitest'

  # Create haml view automatically
  gem 'haml-rails'

  # Catches mail from development environment and shows us.
  gem "mailcatcher"

  # Show rails log inside chrome RailsPanel extension
  gem 'meta_request'

  # Used to create many shortcuts for pow.cx
  gem 'powder'

end

group :test do
  # Including minitest for rails
  gem 'minitest-rails'

  # Used to test app like how a real user would interact
  gem 'minitest-rails-capybara'

  # Test coverage fro whole app
  gem 'simplecov'

  # Clean & colored output for tests
  gem 'turn'
end

group :production do
  # Use memcache
  gem 'dalli'

  # New Relic
  gem 'newrelic_rpm'

  # To enable this Rails 4 to serve your static assets. Basically to make asset precompile to work
  gem 'rails_12factor'

  # Exceptional Notifier send email when error occurs
  gem 'exception_notification'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

