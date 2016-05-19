module Crm
  module Helpers
    module Attributes
      extend ActiveSupport::Concern

      class_methods do
        mattr_accessor :crm_type

        def represents_crm_type(type)
          self.crm_type = type
          @crm_attributes = {}.with_indifferent_access
        end

        def crm_attributes
          return @crm_attributes if @crm_attributes.present?
          raise "#{name}.represents_crm_type(type) needs to be called to fetch its CRM attributes." if crm_type.blank?

          type = Crm::Type.find(crm_type)
          @crm_attributes.merge!(type.standard_attribute_definitions)
          @crm_attributes.merge!(type.attribute_definitions)
        end

        def crm_attr_reader(*attributes)
          @crm_attr_readers ||= []

          attributes.each do |attribute|
            @crm_attr_readers << attribute unless attribute.in?(@crm_attr_readers)
            next if methods.include?(attribute.to_sym)
            raise "Attribute '#{attribute}' does not exist for a CRM #{crm_type}." if crm_attributes[attribute].blank?

            define_method attribute do
              crm_attributes[attribute]
            end
          end
        end

        def crm_attr_readers
          @crm_attr_readers ||= []
        end

        def crm_attr_writer(*attributes)
          @crm_attr_writers ||= []

          attributes.each do |attribute|
            method_name = "#{attribute}=".to_sym
            @crm_attr_writers << method_name unless method_name.in?(@crm_attr_writers)
            next if methods.include?(method_name)
            raise "Attribute '#{attribute}' does not exist for a CRM #{crm_type}." if crm_attributes[attribute].blank?

            define_method method_name do |value|
              crm_attributes[attribute] = value
            end
          end
        end

        def crm_attr_writers
          @crm_attr_writers || []
        end

        def crm_attr_accessor(*attributes)
          crm_attr_reader(*attributes)
          crm_attr_writer(*attributes)
        end
      end

      protected

      def crm_attributes
        @crm_attributes ||= {}
      end
    end
  end
end
