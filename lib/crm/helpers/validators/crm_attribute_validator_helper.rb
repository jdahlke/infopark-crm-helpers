module Crm
  module Helpers
    module Validators
      module CrmAttributeValidatorHelper
        protected

        def crm_attribute_definition(record, attribute)
          record.class.crm_attributes[attribute]
        end
      end
    end
  end
end
