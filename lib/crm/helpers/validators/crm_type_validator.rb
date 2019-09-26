# frozen_string_literal: true

module Crm
  module Helpers
    module Validators
      class CrmTypeValidator < ActiveModel::Validator
        include CrmValidatorHelper

        def validate(record)
          crm_type_definition(record).each_pair do |attribute, definition|
            record.validates_presence_of attribute if definition[:mandatory]

            reader = attribute.to_sym
            next unless record.respond_to?(reader)
            value = record.send(reader)
            next if value.blank?

            attribute_type = definition['attribute_type']
            validator = "::Crm::Helpers::Validators::Crm#{attribute_type.camelcase}Validator".constantize
            record.validates_with validator, attributes: [attribute]
          end
        end
      end
    end
  end
end
