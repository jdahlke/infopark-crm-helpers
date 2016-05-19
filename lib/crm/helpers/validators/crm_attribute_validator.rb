module Crm
  module Helpers
    module Validators
      class CrmAttributeValidator < ::ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return if value.blank?
          definition = record.class.crm_attributes[attribute]

          case definition['attribute_type']
          when 'boolean'
            record.validates_inclusion_of attribute, in: [true, false]
          when 'datetime'
            record.validates_with ::Crm::Helpers::Validators::CrmDatetimeValidator, attributes: [attribute]
          when 'enum'
            record.validates_inclusion_of attribute, in: definition['valid_values'] if definition['valid_values'].present?
          when 'integer'
            record.validates_numericality_of attribute, only_integer: true
          when 'list'
            record.validates_with ::Crm::Helpers::Validators::CrmListValidator, attributes: [attribute]
          when 'multienum'
            record.validates_with ::Crm::Helpers::Validators::CrmMultienumValidator, attributes: [attribute], valid_values: definition['valid_values']
          when 'string'
            record.validates_length_of attribute, maximum: definition['max_length'] if definition['max_length'].present?
          when 'text'
            record.validates_length_of attribute, maximum: definition['max_length'] if definition['max_length'].present?
          end
        end
      end
    end
  end
end
