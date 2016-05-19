$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'crm/helpers'
require 'yaml'

# Configure the CRM
crm_config_path = File.expand_path('../../.crm.yml', __FILE__)
crm_config = YAML.load_file(crm_config_path)
Crm.configure do |config|
  config.tenant  = crm_config['tenant']
  config.login   = crm_config['login']
  config.api_key = crm_config['api_key']
end
