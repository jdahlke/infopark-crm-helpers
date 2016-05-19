$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'crm/helpers'
require 'yaml'

# Configure the CRM
crm_config_path = File.expand_path('../../.crm.yml', __FILE__)
crm_config = if File.exist?(crm_config_path)
               YAML.load_file(crm_config_path)
             else
               {}
             end

Crm.configure do |config|
  config.tenant  = ENV['WEBCRM_TENANT'] || crm_config['tenant']
  config.login   = ENV['WEBCRM_LOGIN'] || crm_config['login']
  config.api_key = ENV['WEBCRM_API_KEY'] || crm_config['api_key']
end
