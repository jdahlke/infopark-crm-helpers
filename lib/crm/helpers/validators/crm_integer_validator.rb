module Crm
  module Helpers
    module Validators
      class CrmIntegerValidator < CrmEachValidator
        def validate_each(record, attribute, _)
          record.validates_numericality_of attribute, only_integer: true
        end
      end
    end
  end
end
