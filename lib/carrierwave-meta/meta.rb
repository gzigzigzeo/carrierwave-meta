module CarrierWave
  module Meta
    extend ActiveSupport::Concern

    included do
      include CarrierWave::ModelDelegateAttribute
      include CarrierWave::MimeTypes

      set_content_type(true)
      
      after :retrieve_from_cache, :set_content_type
      after :retrieve_from_cache, :call_store_meta
      after :retrieve_from_store, :set_content_type
      after :retrieve_from_store, :call_store_meta

      model_delegate_attribute :content_type, ''
      model_delegate_attribute :file_size, 0
      model_delegate_attribute :image_size, []
      model_delegate_attribute :width, 0
      model_delegate_attribute :height, 0
    end

    module InstanceMethods
      def store_meta
        if self.file.present?
          dimensions = get_dimensions
          width, height = dimensions
          self.content_type = self.file.content_type
          self.file_size = self.file.size
          self.image_size = dimensions
          self.width = width
          self.height = height
        end
      end
      
      def set_content_type(file = nil)
        set_content_type(true)
      end
      
      def image_size_s
        image_size.join('x')
      end
      
      private
      def call_store_meta(file = nil)
        # Re-retrieve metadata for a file only if model is not present OR model is not saved.
        store_meta if self.model.nil? || (self.model.respond_to?(:new_record?) && self.model.new_record?)
      end
      
      def get_dimensions
        [].tap do |size|
          if self.file.content_type =~ /image/
            manipulate! do |img|
              if defined?(::Magick::Image) && img.is_a?(::Magick::Image)
                size << img.columns
                size << img.rows
              elsif defined?(::MiniMagick::Image) && img.is_a?(::MiniMagick::Image)
                size << img["width"]
                size << img["height"]
              else
                raise "Only RMagick is supported yet. Fork and update it."
              end        
              img
            end
          end
        end
      end        
    end
  end
end