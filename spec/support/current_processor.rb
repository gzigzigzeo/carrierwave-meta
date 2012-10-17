module CurrentProcessor
  extend ::ActiveSupport::Concern

  included do
    case PROCESSOR
    when :mini_magick
      include CarrierWave::MiniMagick
    when :image_sorcery
      include CarrierWave::ImageSorcery
    else
      include CarrierWave::RMagick
    end
  end
end