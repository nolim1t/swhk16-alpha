CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY'],                        # required
    aws_secret_access_key: ENV['AWS_SECRET_KEY'],                        # required
    region:                ENV['AWS_REGION'] || 'us-east-1',                  # optional, defaults to 'us-east-1'
    host:                  's3.amazonaws.com',             # optional, defaults to nil
    endpoint:              'https://s3.amazonaws.com/' # optional, defaults to nil
  }
  config.fog_directory  = ENV['S3_BUCKET_NAME'] || 'vaultron-beta-dev'                          # required
  config.fog_public     = true                                      # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
end
