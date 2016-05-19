module Crm
  module Helpers
    module Validators
      class CrmDatetimeValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return if value.is_a?(Date)
          return if value.is_a?(Time)
          return if value.is_a?(DateTime)

          record.errors.add(attribute, I18n.t('activerecord.errors.messages.invalid_datetime'))
        end
      end
    end
  end
end
