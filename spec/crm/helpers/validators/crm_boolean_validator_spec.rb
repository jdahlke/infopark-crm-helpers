require 'spec_helper'

include CrmValidatorSpecHelper

validator = Crm::Helpers::Validators::CrmBooleanValidator

attribute_type = {
  attribute_type: 'boolean',
  mandatory: false
}.with_indifferent_access

invalid_values = ['Hello', 123, ['Haha'], { foo: :bar }]
valid_values = [true, false]

options = {
  crm_attributes: {
    attribute: attribute_type
  },
  invalid_values: invalid_values,
  valid_values: valid_values
}

run_specs_for_crm_validator!(validator, options)
