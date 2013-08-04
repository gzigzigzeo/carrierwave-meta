if ENV['REMOTE'] == 'true'
  Fog.mock!

  Fog.credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'xxx',
    :aws_secret_access_key  => 'yyy',
    :region                 => 'eu-west-1',
    :host                   => 's3.example.com',
    :endpoint               => 'https://s3.example.com:8080'
  }

  connection = Fog::Storage.new(:provider => 'AWS')
  connection.directories.create(:key => 'dev-bucket')

  CarrierWave.configure do |config|
    config.fog_credentials = Fog.credentials
    config.fog_directory   = 'dev-bucket'
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
    config.storage        = :fog
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
