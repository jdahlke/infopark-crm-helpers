require 'spec_helper'

include CrmValidatorSpecHelper

validator = Crm::Helpers::Validators::CrmEnumValidator

attribute_type = {
  attribute_type: 'enum',
  mandatory: false,
  valid_values: [2, 3, 5, 7, 11, 13, 17, 19]
}.with_indifferent_access

invalid_values = ['Hello', 123, { foo: :bar }, [2, 3]]
valid_values = [2, 3]

options = {
  crm_attributes: {
    attribute: attribute_type
  },
  invalid_values: invalid_values,
  valid_values: valid_values
}

run_specs_for_crm_validator(validator, options)
