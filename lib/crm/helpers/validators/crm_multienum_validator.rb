module Crm
  module Helpers
    module Validators
      class CrmMultienumValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, values)
          unless values.is_a?(Array)
            record.errors.add(attribute, I18n.t('activerecord.errors.messages.not_a_list'))
            return
          end

          invalid_values = values.reject { |value| value.in?(options[:valid_values]) }
          return if invalid_values.blank?

          message = I18n.t('activerecord.errors.messages.cannot_contain_values', values: invalid_values.join(', '))
          record.errors.add(attribute, message)
        end
      end
    end
  end
end
