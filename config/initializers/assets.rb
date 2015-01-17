# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Add ckeditor files - otherwise missing on production  Rails.application.config.assets.precompile += %w( ckeditor/* )
# Add railsstrap glyphicons - otherwise missing on production   Rails.application.config.assets.precompile += %w( fontawesome/fonts/fontawesome-webfont.eot fontawesome/fonts/fontawesome-webfont.woff fontawesome/fonts/fontawesome-webfont.ttf fontawesome/fonts/fontawesome-webfont.svg)
Rails.application.config.assets.precompile += %w( ckeditor/* bootstrap/fonts/* fontawesome/fonts/* )