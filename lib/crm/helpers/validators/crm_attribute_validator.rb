module Crm
  module Helpers
    module Validators
      class CrmAttributeValidator < ::ActiveModel::EachValidator
        include Crm::Helpers::Validators::CrmAttributeValidatorHelper

        def validate_each(record, attribute, value)
          definition = crm_attribute_definition(record, attribute)
          attribute_type = definition['attribute_type'].camelcase

          record.validates_presence_of attribute if definition['mandatory']
          return if value.blank?

          validator = "::Crm::Helpers::Validators::Crm#{attribute_type}Validator".constantize
          record.validates_with validator, attributes: [attribute]
        end
      end
    end
  end
end
