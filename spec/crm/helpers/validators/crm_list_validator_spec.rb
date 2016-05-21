require 'spec_helper'

include CrmAttributeValidatorSpecHelper

validator = Crm::Helpers::Validators::CrmListValidator

attribute_type = {
  attribute_type: 'datetime',
  mandatory: false
}.with_indifferent_access

invalid_values = ['Hello', 123.456, 2.0, { foo: :bar }, true]
valid_values = [[2, 3, 5, 7]]

options = {
  crm_attributes: {
    attribute: attribute_type
  },
  invalid_values: invalid_values,
  valid_values: valid_values
}

run_specs_for_crm_attribute_validator(validator, options)
