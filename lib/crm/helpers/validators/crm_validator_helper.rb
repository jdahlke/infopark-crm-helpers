# frozen_string_literal: true

module Crm
  module Helpers
    module Validators
      module CrmValidatorHelper
        protected

        def crm_type_definition(record)
          record.class.try(:crm_attributes) || {}
        end

        def crm_attribute_definition(record, attribute)
          crm_type_definition(record)[attribute]
        end
      end
    end
  end
end
