module Crm
  module Helpers
    module Validators
      class CrmMultienumValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, values)
          unless values.kind_of?(Array)
            record.errors.add(attribute, I18n.t('activerecord.errors.messages.not_a_list'))
            return
          end

          invalid_values = values.reject { |value| value.in?(options[:valid_values]) }
          return if invalid_values.blank?

          record.errors.add(attribute, I18n.t('activerecord.errors.messages.cannot_contain_values', values: invalid_values.join(', ')))
        end
      end
    end
  end
end
