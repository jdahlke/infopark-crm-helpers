module Crm
  module Helpers
    module Validators
      class CrmListValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          record.errors.add(attribute, I18n.t('activerecord.errors.messages.not_a_list')) unless value.kind_of?(Array)
        end
      end
    end
  end
end
