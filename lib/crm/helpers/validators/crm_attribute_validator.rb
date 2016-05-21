module Crm
  module Helpers
    module Validators
      class CrmAttributeValidator < CrmEachValidator
        include CrmValidatorHelper

        def validate_each(record, attribute, value)
          definition = crm_attribute_definition(record, attribute)

          record.validates_presence_of attribute if definition['mandatory']
          return if value.blank?

          attribute_type = definition['attribute_type']
          validator = "::Crm::Helpers::Validators::Crm#{attribute_type.camelcase}Validator".constantize
          record.validates_with validator, attributes: [attribute]
        end
      end
    end
  end
end
