# frozen_string_literal: true

require 'spec_helper'

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

RSpec.describe validator, type: :validator do
  include_examples 'crm attribute validator', validator, options
end
