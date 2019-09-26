# frozen_string_literal: true

require 'spec_helper'

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

RSpec.describe validator, type: :validator do
  include_examples 'crm attribute validator', validator, options
end
