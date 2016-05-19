module Crm
  module Helpers
    module Validators
      class CrmDatetimeValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return if value.kind_of?(Date)
          return if value.kind_of?(Time)
          return if value.kind_of?(DateTime)

          record.errors.add(attribute, I18n.t('activerecord.errors.messages.invalid_datetime'))
        end
      end
    end
  end
end
