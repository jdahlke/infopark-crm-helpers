module Crm
  module Helpers
    module Validators
      class CrmTextValidator < ActiveModel::EachValidator
        include Crm::Helpers::Validators::CrmValidatorHelper

        def validate_each(record, attribute, _)
          definition = crm_attribute_definition(record, attribute)
          record.validates_length_of attribute, maximum: definition['max_length']
        end
      end
    end
  end
end
