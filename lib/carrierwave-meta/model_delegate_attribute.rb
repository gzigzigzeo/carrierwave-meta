module CarrierWave
  module ModelDelegateAttribute
    extend ::ActiveSupport::Concern
    
    module ClassMethods
      def model_delegate_attribute(attribute, default = nil)
        attr_accessor attribute

        before :remove, :"reset_#{attribute}"

        var_name = :"@#{attribute}"

        define_method :"#{attribute}" do
          model_accessor = model_getter_name(attribute)
          value = instance_variable_get(var_name)
          value ||= self.model.send(model_accessor) if self.model.present? && self.model.respond_to?(model_accessor)
          value ||= default
          instance_variable_set(var_name, value)
        end

        define_method :"#{attribute}=" do |value|
          model_accessor = model_getter_name(attribute)
          instance_variable_set(var_name, value)
          if self.model.present? && self.model.respond_to?(:"#{model_accessor}=") && !self.model.destroyed?
            self.model.send(:"#{model_accessor}=", value) 
          end
        end

        define_method :"reset_#{attribute}" do
          self.send(:"#{attribute}=", default)
          send(:"#{attribute}=", default)
        end
      end
    end
    
    module InstanceMethods
      private
      def model_getter_name(attribute)
        name = []
        name << mounted_as if mounted_as.present?
        name << version_name if version_name.present?
        name << attribute
        name.join('_')
      end
    end
  end
end
