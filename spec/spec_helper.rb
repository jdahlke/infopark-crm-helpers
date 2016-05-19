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
    stub_crm_type(:get, :account)
    stub_crm_type(:get, :contact)
    stub_crm_type(:get, :does_not_exist, status: ['404', 'Not Found'])
  end
end
