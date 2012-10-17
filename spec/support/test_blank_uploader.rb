class TestBlankUploader < CarrierWave::Uploader::Base
  include CurrentProcessor
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