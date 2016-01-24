# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( landing.css )
Rails.application.config.assets.precompile += %w( Logo.png )
Rails.application.config.assets.precompile += %w( front.jpg )
Rails.application.config.assets.precompile += %w( back.jpg )
Rails.application.config.assets.precompile += %w( front_1.jpg )
Rails.application.config.assets.precompile += %w( back_1.jpg )
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
