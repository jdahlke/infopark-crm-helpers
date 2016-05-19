module Crm
  module Helper
    def self.included(base)
      base.include Crm::Helpers::Attributes
      base.include Crm::Helpers::Validations
    end
  end
end
