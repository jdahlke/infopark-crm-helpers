module Crm
  module Helpers
    module Validators
      class CrmBooleanValidator < ActiveModel::EachValidator
        include Crm::Helpers::Validators::CrmValidatorHelper

        def validate_each(record, attribute, _)
          record.validates_inclusion_of attribute, in: [true, false]
        end
      end
    end
  end
end
