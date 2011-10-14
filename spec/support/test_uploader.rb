class TestUploader < CarrierWave::Uploader::Base
  if PROCESSOR == :mini_magick
    include CarrierWave::MiniMagick
  else
    include CarrierWave::RMagick
  end
  include CarrierWave::Meta
  
  def store_dir
    "tmp/store"
  end

  def cache_dir
    "tmp/cache"
  end

  storage :file

  process :store_meta
  version :version do
    process :resize_to_fill => [200, 200]
    process :store_meta
  end
end