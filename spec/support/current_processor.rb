module CurrentProcessor
  extend ::ActiveSupport::Concern

  included do
    case PROCESSOR
    when :image_sorcery
      require 'carrierwave-imagesorcery'
      include CarrierWave::ImageSorcery
    when :vips
      require 'carrierwave-vips'
      include CarrierWave::Vips
    when :mini_magick
      include CarrierWave::MiniMagick
    else
      include CarrierWave::RMagick
    end
  end
end