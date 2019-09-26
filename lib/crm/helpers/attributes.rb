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
          crm_attributes.select { |_, definition| definition[:mandatory] }.keys.sort.map(&:to_sym)
        end

        def crm_attributes
          return @crm_attributes if @crm_attributes.present?
          raise "#{name}.represents_crm_type(type) needs to be called to fetch its CRM attributes." if crm_type.blank?

          collect_crm_attributes_data(crm_type)
        end

        def crm_attr_reader(*attributes)
          @crm_attr_readers ||= []

          attributes.each do |attribute|
            @crm_attr_readers << attribute unless attribute.in?(@crm_attr_readers)
            next if instance_methods.include?(attribute.to_sym)
            raise "Attribute '#{attribute}' does not exist for a CRM #{crm_type}." if crm_attributes[attribute].blank?

            define_method attribute do
              crm_attributes[attribute]
            end
          end
        end

        def crm_attr_readers
          @crm_attr_readers.sort ||= []
        end

        def crm_attr_writer(*attributes)
          @crm_attr_writers ||= []

          attributes.each do |attribute|
            method_name = "#{attribute}=".to_sym
            @crm_attr_writers << method_name unless method_name.in?(@crm_attr_writers)
            next if instance_methods.include?(method_name)
            raise "Attribute '#{attribute}' does not exist for a CRM #{crm_type}." if crm_attributes[attribute].blank?

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

      def assign_attributes(new_attributes)
        deprecation_message = [
          '[DEPRECATION]',
          '`Crm::Helpers::Attributes#assign_attributes` is deprecated.',
          'Please use `Crm::Helpers::Attributes#assign_crm_attributes` instead.',
          '`Crm::Helpers::Attributes#assign_attributes` will be removed in version 2.0.0.'
        ].join(' ')
        STDERR.puts(deprecation_message)
        assign_crm_attributes(new_attributes)
      end

      def crm_attributes
        @crm_attributes ||= {}
      end
    end
  end
end
