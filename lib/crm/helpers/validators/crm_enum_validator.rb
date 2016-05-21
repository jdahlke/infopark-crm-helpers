module Crm
  module Helpers
    module Validators
      class CrmEnumValidator < CrmEachValidator
        include CrmValidatorHelper

        def validate_each(record, attribute, _)
          definition = crm_attribute_definition(record, attribute)
          record.validates_inclusion_of attribute, in: definition['valid_values']
        end
      end
    end
  end
end
