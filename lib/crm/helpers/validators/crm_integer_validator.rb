module Crm
  module Helpers
    module Validators
      class CrmIntegerValidator < ActiveModel::EachValidator
        include Crm::Helpers::Validators::CrmAttributeValidatorHelper

        def validate_each(record, attribute, _)
          record.validates_numericality_of attribute, only_integer: true
        end
      end
    end
  end
end
