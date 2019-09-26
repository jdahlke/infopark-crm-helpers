# frozen_string_literal: true

require 'spec_helper'

validator = Crm::Helpers::Validators::CrmMultienumValidator

attribute_type = {
  attribute_type: 'multienum',
  mandatory: false,
  valid_values: [2, 3, 5, 7, 11, 13, 17, 19]
}.with_indifferent_access

invalid_values = ['Hello', 123, ['Haha'], { foo: :bar }, [2, 3, 5, 7, 9], [4]]
valid_values = [[2, 3, 5, 7], [2, 19]]

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
