module CarrierWave
  module Meta
    module ActiveRecord
      ALLOWED = %w(width height md5sum image_size file_size content_type)

      def carrierwave_meta_composed(single_attribute, *args)
        defined_attrs = args.map do |arg|
          name, to_define = if arg.is_a?(Symbol)
            [arg, ALLOWED]
          elsif arg.is_a?(Hash)
            [arg.keys.first, arg.values.first]
          end

          to_define.map do |attr|
            delegate :"#{name}_#{attr}", to: single_attribute, allow_nil: true
            delegate :"#{name}_#{attr}=", to: single_attribute, allow_nil: true
          end
        end
      end
    end
  end
end