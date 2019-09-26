# frozen_string_literal: true

module Crm
  module Helper
    def self.included(base)
      base.include Crm::Helpers::Attributes
      base.include Crm::Helpers::Finders
      base.include Crm::Helpers::Persistence
    end
  end
end
