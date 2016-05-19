require 'active_model'
require 'active_support/all'
require 'infopark_webcrm_sdk'

require 'crm/helpers/validators/crm_attribute_validator'
require 'crm/helpers/validators/crm_datetime_validator'
require 'crm/helpers/validators/crm_list_validator'
require 'crm/helpers/validators/crm_multienum_validator'

require 'crm/helpers/attributes'
require 'crm/helpers/validations'
require 'crm/helpers/version'

module Crm
  module Helpers
    def self.included(base)
      base.include Crm::Helpers::Attributes
      base.include Crm::Helpers::Validations
    end
  end
end
