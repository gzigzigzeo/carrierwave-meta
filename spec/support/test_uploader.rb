class TestUploader < CarrierWave::Uploader::Base
  include CurrentProcessor
  include CarrierWave::Meta

  def store_dir
    "tmp/store"
  end

  def cache_dir
    "tmp/cache"
  end

  process :store_meta => [{md5sum: true}]
  version :version do
    process :resize_to_fill => [200, 200], :if => :image_file?
    process :store_meta
  end

  def image_file? file
    file.content_type =~ /image/
  end
end