# frozen_string_literal: true

module Crm
  module Helpers
    module Attributes
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        attr_reader :crm_type

        def represents_crm_type(crm_type)
          @crm_type = crm_type
          @crm_class = nil
          @crm_attributes = {}.with_indifferent_access

          crm_attr_accessor(*mandatory_crm_attributes)
        end

        def crm_class
          return nil if @crm_type.blank?
          return @crm_class if @crm_class.present?

          type_definition = crm_type_definition(crm_type)
          class_name = "Crm::#{type_definition.item_base_type}"
          @crm_class = class_name.constantize
        end

        def mandatory_crm_attributes
          crm_attributes.select do |_, definition|
            definition[:mandatory]
          end.keys.sort.map(&:to_sym)
        end

        def crm_attributes
          return @crm_attributes if @crm_attributes.present?

          if crm_type.blank?
            raise "#{name}.represents_crm_type(type) needs to be called " \
                  'to fetch its CRM attributes.'
          end

          collect_crm_attributes_data(crm_type)
        end

        def crm_attr_reader(*attributes)
          @crm_attr_readers ||= Set.new

          attributes.each do |attribute|
            @crm_attr_readers << attribute
            next if instance_methods.include?(attribute.to_sym)

            check_attribute(attribute)

            define_method attribute do
              crm_attributes[attribute]
            end
          end
        end

        def crm_attr_readers
          @crm_attr_readers.sort ||= []
        end

        def crm_attr_writer(*attributes)
          @crm_attr_writers ||= Set.new

          attributes.each do |attribute|
            method_name = "#{attribute}=".to_sym
            @crm_attr_writers << method_name
            next if instance_methods.include?(method_name)

            check_attribute(attribute)

            define_method method_name do |value|
              crm_attributes[attribute] = value
            end
          end
        end

        def crm_attr_writers
          @crm_attr_writers.sort || []
        end

        def crm_attr_accessor(*attributes)
          crm_attr_reader(*attributes)
          crm_attr_writer(*attributes)
        end

        protected

        def check_attribute(attribute)
          return if crm_attributes[attribute].present?

          raise "Attribute '#{attribute}' does not exist for a CRM #{crm_type}."
        end

        def collect_crm_attributes_data(crm_type)
          type = crm_type_definition(crm_type)
          @crm_attributes = type.standard_attribute_definitions
          @crm_attributes.merge!(type.attribute_definitions)
        end

        def crm_type_definition(crm_type)
          Crm::Type.find(crm_type)
        end
      end

      def assign_crm_attributes(new_attributes)
        @crm_attributes = crm_attributes.merge(new_attributes)
      end

      def crm_attributes
        @crm_attributes ||= {}
      end
    end
  end
end
