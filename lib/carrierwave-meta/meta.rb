module CarrierWave
  module Meta
    extend ActiveSupport::Concern

    mattr_accessor :ghostscript_enabled
    self.ghostscript_enabled = false

    included do
      include CarrierWave::ModelDelegateAttribute
      include CarrierWave::MimeTypes

      set_content_type(true)

      after :retrieve_from_cache, :set_content_type
      after :retrieve_from_cache, :call_store_meta
      after :retrieve_from_store, :set_content_type unless storage.name =~ /Fog/
      after :retrieve_from_store, :call_store_meta

      model_delegate_attribute :content_type, ''
      model_delegate_attribute :file_size, 0
      model_delegate_attribute :image_size, []
      model_delegate_attribute :width, 0
      model_delegate_attribute :height, 0
      model_delegate_attribute :md5sum, ''
    end

    def store_meta(options = {})
      if self.file.present?
        dimensions = get_dimensions
        width, height = dimensions
        self.content_type = self.file.content_type
        self.file_size = self.file.size
        self.image_size = dimensions
        self.width = width
        self.height = height
        if options[:md5sum]
          self.md5sum = Digest::MD5.hexdigest(File.read(self.file.path))
        end
      end
    end

    def image_size_s
      image_size.join('x')
    end

    private
    def call_store_meta(file = nil)
      # Re-retrieve metadata for a file only if model is not present OR
      # model is not saved.
      if model.nil? || (model.respond_to?(:new_record?) && model.new_record?)
        processor_options = processors.
          find { |p| p.first == :store_meta }.
          try(:[], 1)

        store_meta(*processor_options)
      end
    end

    def get_dimensions
      [].tap do |size|
        is_image = file.content_type =~ /image/
        is_pdf =
          file.content_type =~ /postscript|pdf/ &&
          CarrierWave::Meta.ghostscript_enabled

        is_dimensionable = is_image || is_pdf

        manipulate! do |img|
          if processor?(:rmagick, img) && is_dimensionable
            size << img.columns
            size << img.rows
          elsif processor?(:mini_magick, img) && is_dimensionable
            size << img['width']
            size << img['height']
          elsif processor?(:socrecy, img) && is_image
            size << img.dimensions[:x].to_i
            size << img.dimensions[:y].to_i
          elsif processor?(:vips, img) && is_image
            size << img.x_size
            size << img.y_size
          else
            raise "Unsupported file type/image processor (use RMagick, MiniMagick, ImageSorcery, VIPS)"
          end
          img
        end
      end
    rescue CarrierWave::ProcessingError
    end

    def processor?(processor, img)
      processor = PROCESSORS[processor]
      processor_class = processor.constantize rescue nil
      processor_class.present? && img.is_a?(processor_class)
    end

    PROCESSORS = {
      rmagick: 'Magick::Image',
      mini_magick: 'MiniMagick::Image',
      socrecy: 'ImageSorcery',
      vips: 'VIPS::Image'
    }
  end
end
