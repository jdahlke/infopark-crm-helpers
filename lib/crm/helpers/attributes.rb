module Crm
  module Helpers
    module Attributes
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        attr_reader :crm_type

        def represents_crm_type(type)
          @crm_type = type
          @crm_attributes = {}.with_indifferent_access
          crm_attr_accessor(*mandatory_crm_attributes)
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
            next if methods.include?(attribute.to_sym)
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
            next if methods.include?(method_name)
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
          type = Crm::Type.find(crm_type)
          @crm_attributes = type.standard_attribute_definitions
          # This is a lovely hack, because the language attribute does not get
          # the correct valid values in #standard_attribute_definitions. Maybe
          # soon, when Thomas Ritz is back from warkation...
          @crm_attributes[:language][:valid_values] += type.languages if @crm_attributes[:language].present?
          @crm_attributes.merge!(type.attribute_definitions)
        end
      end

      def crm_attributes
        @crm_attributes ||= {}
      end
    end
  end
end
