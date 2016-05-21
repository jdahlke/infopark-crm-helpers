module Crm
  module Helpers
    module Validators
      module CrmAttributeValidatorHelper
        protected

        def crm_attribute_definition(record, attribute)
          return {} unless record.class.methods.include?(:crm_attributes)
          record.class.crm_attributes[attribute]
        end
      end
    end
  end
end
