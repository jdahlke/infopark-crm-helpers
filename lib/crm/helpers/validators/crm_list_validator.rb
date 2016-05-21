module Crm
  module Helpers
    module Validators
      class CrmListValidator < ActiveModel::EachValidator
        include Crm::Helpers::Validators::CrmValidatorHelper

        def validate_each(record, attribute, value)
          record.errors.add(attribute, I18n.t('activerecord.errors.messages.not_a_list')) unless value.is_a?(Array)
        end
      end
    end
  end
end
