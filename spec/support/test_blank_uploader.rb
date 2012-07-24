class TestBlankUploader < CarrierWave::Uploader::Base
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
end