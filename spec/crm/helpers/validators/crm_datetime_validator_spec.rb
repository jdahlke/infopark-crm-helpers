require 'spec_helper'

include CrmValidatorSpecHelper

validator = Crm::Helpers::Validators::CrmDatetimeValidator

attribute_type = {
  attribute_type: 'datetime',
  mandatory: false
}.with_indifferent_access

invalid_values = ['Hello', 123, ['Haha'], { foo: :bar }, [2, 3, 5, 7, 9], [4]]
valid_values = [Date.today, Time.now, DateTime.now]

options = {
  crm_attributes: {
    attribute: attribute_type
  },
  invalid_values: invalid_values,
  valid_values: valid_values
}

run_specs_for_crm_validator(validator, options)
