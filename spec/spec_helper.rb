$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'crm/helpers'

require 'support/crm_helper'
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
    stub_crm_request(:get, 'types/account')
    stub_crm_request(:get, 'types/contact')
    stub_crm_request(:get, 'types/does_not_exist', status: ['404', 'Not Found'])
  end
end
