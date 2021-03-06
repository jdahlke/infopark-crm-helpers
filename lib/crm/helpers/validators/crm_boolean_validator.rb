# frozen_string_literal: true

module Crm
  module Helpers
    module Validators
      class CrmBooleanValidator < CrmEachValidator
        def validate_each(record, attribute, _)
          record.validates_inclusion_of attribute, in: [true, false]
        end
      end
    end
  end
end
