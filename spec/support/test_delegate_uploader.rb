class TestDelegateUploader < CarrierWave::Uploader::Base
  VALUES = {
    :x => 5,
    :version_x => 10,
    :dimensions => [1, 1],
    :version_dimensions => [2, 2]
  }
  
  DEFAULT_VALUES = {
    :x => 0,
    :dimensions => []
  }
  
  storage :file

  def store_dir
    "tmp/store"
  end

  def cache_dir
    "tmp/cache"
  end  
  
  include CarrierWave::ModelDelegateAttribute
  
  model_delegate_attribute :x, DEFAULT_VALUES[:x]
  model_delegate_attribute :dimensions, DEFAULT_VALUES[:dimensions]
  
  process :set_values
  version :version do
    process :set_values_for_version
  end
  
  def set_values
    self.x = VALUES[:x]
    self.dimensions = VALUES[:dimensions]
  end
  
  def set_values_for_version
    self.x = VALUES[:version_x]
    self.dimensions = VALUES[:version_dimensions]
  end
end