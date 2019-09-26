# frozen_string_literal: true

module Crm
  module Helpers
    module Validators
      class CrmStringValidator < CrmEachValidator
        def validate_each(record, attribute, _)
          definition = crm_attribute_definition(record, attribute)
          return if definition['max_length'].blank?

          record.validates_length_of attribute,
                                     maximum: definition['max_length']
        end
      end
    end
  end
end
