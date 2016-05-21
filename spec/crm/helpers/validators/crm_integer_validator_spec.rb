require 'spec_helper'

include CrmValidatorSpecHelper

validator = Crm::Helpers::Validators::CrmIntegerValidator

attribute_type = {
  attribute_type: 'datetime',
  mandatory: false
}.with_indifferent_access

invalid_values = ['Hello', 123.456, 2.0, ['Haha'], { foo: :bar }]
valid_values = [-2, 2]

options = {
  crm_attributes: {
    attribute: attribute_type
  },
  invalid_values: invalid_values,
  valid_values: valid_values
}

run_specs_for_crm_validator(validator, options)
