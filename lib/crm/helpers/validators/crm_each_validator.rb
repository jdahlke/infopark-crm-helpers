# frozen_string_literal: true

module Crm
  module Helpers
    module Validators
      class CrmEachValidator < ActiveModel::EachValidator
        include CrmValidatorHelper
      end
    end
  end
end
