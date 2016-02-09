source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'


#mysql2
gem 'mysql2', '~> 0.3.18'
#devise 
gem 'devise', '~> 3.5.6'
#haml
gem 'haml', '~> 4.0.5'
#twitter-bootstrap
gem 'less-rails', '~> 2.7.1'
gem 'railsstrap', '~> 3.3.4'


#carrierwave (requires mini_magick)
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick', '~> 4.4.0'
#simple form
#gem 'simple_form'
#rails-i18n - does not work??
#gem 'rails-i18n', '~> 4.0.0' # For 4.0.x
#mathjax for math support
gem 'mathjax-rails', '~> 2.5.1'
#converter for erbs -> haml
gem 'html2haml', '~> 2.0.0'
#ckeditor gem
gem 'ckeditor', '~> 4.1.6'
#facebook login
gem 'omniauth-facebook', '~> 3.0.0'
#pdf generation
gem 'prawn', '~> 2.0.2'
gem 'prawn-table', '~> 0.2.2'
#devise localization
gem 'devise-i18n', '~> 0.12.1'
#pagination
gem 'kaminari', '~> 0.16.3'
#braintree support
gem 'braintree', '~> 2.57.0'
# add cms settings
gem "rails-settings-cached", "0.4.1"
# add ui for cms settings
gem 'rails-settings-ui', '~> 0.3.0'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Add easy colors to console outputs 'puts'. Read more: https://github.com/fazibear/colorize
gem 'colorize', '~> 0.7.7'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.4'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use older Capistrano version
#gem 'capistrano', '~> 2.5', group: :development
#gem 'capistrano-ext', group: :development
#gem 'rvm-capistrano', group: :development

# Falls du capistrano global als gem und im Gemfile installiert hast musst du aufpassen welches verwendet wird. Mit bundle exec cap ... 
# wird das aus dem Gemfile verwendet und wenn du nur cap ... die globale Version.
group :development do
  gem 'rvm-capistrano', '1.4.4' #ATTENTION: order inportant, must be before capistrano!
  gem 'capistrano', '2.15.5'
  gem 'capistrano-ext', '1.2.1'
end

# Use debugger
# gem 'debugger', group: [:development, :test]

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem #version tzinfo 1.2.2
gem 'tzinfo-data', platforms: [:mingw, :mswin]
