# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

$LOAD_PATH.unshift File.expand_path('/../lib', __dir__)
require 'crm/helpers'

require 'support/crm_helper'
require 'support/crm_attribute_validator_spec_helper'
require 'support/fakeweb'
require 'fakeweb'
require 'pry'
require 'yaml'

RSpec.configure do |config|
  config.include CrmHelper

  config.before :all do
    setup_crm
  end

  config.before :each do
    resources = %w[types types/account types/contact]
    resources.each { |resource| stub_crm_request(:get, resource) }
    stub_crm_request(:get, 'types/does_not_exist', status: ['404', 'Not Found'])
  end
end
