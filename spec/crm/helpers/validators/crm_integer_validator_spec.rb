# frozen_string_literal: true

require 'spec_helper'

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

RSpec.describe validator, type: :validator do
  include_examples 'crm attribute validator', validator, options
end
