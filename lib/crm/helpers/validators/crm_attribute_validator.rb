module Crm
  module Helpers
    module Validators
      class CrmAttributeValidator < ::ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return if value.blank?
          definition = record.class.crm_attributes[attribute]

          known_types = %i(boolean datetime enum integer list multienum string text)
          attribute_type = definition['attribute_type'].to_sym
          return unless attribute_type.in?(known_types)

          send("validate_#{attribute_type}".to_sym, record, attribute, definition)
        end

        protected

        def validate_boolean(record, attribute, _)
          record.validates_inclusion_of attribute, in: [true, false]
        end

        def validate_datetime(record, attribute, _)
          record.validates_with ::Crm::Helpers::Validators::CrmDatetimeValidator, attributes: [attribute]
        end

        def validate_enum(record, attribute, definition)
          return if definition['valid_values'].blank?
          record.validates_inclusion_of attribute, in: definition['valid_values']
        end

        def validate_integer(record, attribute, _)
          record.validates_numericality_of attribute, only_integer: true
        end

        def validate_list(record, attribute, _)
          record.validates_with ::Crm::Helpers::Validators::CrmListValidator, attributes: [attribute]
        end

        def validate_multienum(record, attribute, definition)
          record.validates_with ::Crm::Helpers::Validators::CrmMultienumValidator,
                                attributes: [attribute],
                                valid_values: definition['valid_values']
        end

        def validate_string(record, attribute, definition)
          return if definition['max_length'].blank?
          record.validates_length_of attribute, maximum: definition['max_length']
        end

        def validate_text(record, attribute, definition)
          return if definition['max_length'].blank?
          record.validates_length_of attribute, maximum: definition['max_length']
        end
      end
    end
  end
end
