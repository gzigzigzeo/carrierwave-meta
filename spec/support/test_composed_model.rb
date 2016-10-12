class TestComposedModel < ActiveRecord::Base
  extend CarrierWave::Meta::ActiveRecord

  mount_uploader :image, TestUploader
  serialize :image_meta, OpenStruct
  carrierwave_meta_composed :image_meta, :image, image_version: [:width, :height]
end