# frozen_string_literal: true

require 'spec_helper'

validator = Crm::Helpers::Validators::CrmStringValidator

attribute_type = {
  attribute_type: 'string',
  mandatory: false,
  max_length: 16
}.with_indifferent_access

invalid_values = ['This string is way too long']
valid_values = ['This is short']

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
