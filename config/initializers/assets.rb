# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( landing.css )
Rails.application.config.assets.precompile += %w( logolight.png )
Rails.application.config.assets.precompile += %w( landing1.png )
Rails.application.config.assets.precompile += %w( landing2.png )
Rails.application.config.assets.precompile += %w( landing3.png )
Rails.application.config.assets.precompile += %w( landing4.png )
Rails.application.config.assets.precompile += %w( addcardpicture.png )

Rails.application.config.assets.precompile += %w( 1.jpg )
Rails.application.config.assets.precompile += %w( grid.js )
Rails.application.config.assets.precompile += %w( modernizr.custom.js )
Rails.application.config.assets.precompile += %w( component.css )
Rails.application.config.assets.precompile += %w( expand.js )

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
