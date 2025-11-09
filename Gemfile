source 'https://rubygems.org'

gem 'rails', '~> 8.0.2'
gem 'jbuilder'
gem 'propshaft'
gem 'puma', '>= 5.0'
gem 'kamal', require: false
gem 'bootsnap', require: false
gem 'thruster', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

# Database and Model
gem 'pg', '~> 1.5'
gem 'strong_migrations'

# Front-end
gem 'pagy'
gem 'slim'
gem 'vite_rails'
gem 'turbo-rails'
gem 'simple_form'
gem 'stimulus-rails'

# Files
gem 'image_processing', '~> 1.2'
gem 'active_storage_validations'

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'

# Authentication and Authorization
gem 'pundit'
gem 'devise'
gem 'rolify'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

# Job
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-unique-jobs'

# RabbitMQ
gem 'bunny', '~> 2.22'
gem 'sneakers', '~> 2.12'

# Seed
gem 'faker'
gem 'seedbank'

# Tracking
gem 'stackprof'
gem 'sentry-ruby'
gem 'sentry-rails'

# Others
gem 'enumerize'
gem 'web-console'

group :development, :test do
  gem 'brakeman', require: false
  gem 'rspec-rails'
  gem 'dotenv', '>= 3.0'
  gem 'factory_bot_rails'
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
end

group :development do
  gem 'pry'
  gem 'bullet'
  gem 'annotate'
  gem 'lefthook'
  gem 'i18n-tasks'
  gem 'letter_opener'
  gem 'pgcli-rails'
  gem 'rails-mermaid_erd'
  gem 'bundler-audit', require: false
  gem 'ruby-lsp'
  gem 'ruby-lsp-rails'
  gem 'rubocop', require: false
  gem 'rubocop-slim', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'capybara'
  gem 'pundit-matchers'
  gem 'shoulda-matchers'
  gem 'selenium-webdriver'
  gem 'rails-controller-testing'
  gem 'simplecov', require: false
end
