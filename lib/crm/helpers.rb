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
    extend ActiveSupport::Concern
    include Crm::Helpers::Attributes
    include Crm::Helpers::Validations
  end
end
