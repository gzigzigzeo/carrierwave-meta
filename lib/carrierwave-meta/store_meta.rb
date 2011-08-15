module CarrierWave
  module Meta
    extend ActiveSupport::Concern

    included do
      include CarrierWave::ModelDelegateAttribute
      
      after :retrieve_from_cache, :store_meta

      model_delegate_attribute :content_type, ''
      model_delegate_attribute :file_size, 0
      model_delegate_attribute :image_size, []
      model_delegate_attribute :width, 0
      model_delegate_attribute :height, 0
    end

    module InstanceMethods
      def store_meta(file = nil)
        puts 'before'
        if self.file.present?
          puts 'in'
          dimensions = get_dimensions
          width, height = dimensions
puts dimensions.inspect
puts self.file.inspect
          self.content_type = self.file.content_type
          self.file_size = self.file.size
          self.image_size = dimensions
          self.width = width
          self.height = height
        end
      end
      
      private    
      def get_dimensions
        [].tap do |size|
          puts 'started'
          if self.file.content_type =~ /image/
            manipulate! do |img|
              if img.is_a?(::Magick::Image)
                size << img.columns
                size << img.rows
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