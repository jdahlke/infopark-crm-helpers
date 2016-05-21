module Crm
  module Helpers
    module Validators
      class CrmMultienumValidator < CrmEachValidator
        include CrmValidatorHelper

        def validate_each(record, attribute, values)
          return unless a_multienum?(record, attribute, values)

          definition = crm_attribute_definition(record, attribute)
          valid_values = definition['valid_values']

          invalid_values = values.reject { |value| value.in?(valid_values) }
          return if invalid_values.blank?

          message = I18n.t('activerecord.errors.messages.cannot_contain_values', values: invalid_values.join(', '))
          record.errors.add(attribute, message)
        end

        protected

        def a_multienum?(record, attribute, values)
          unless values.is_a?(Array)
            record.errors.add(attribute, I18n.t('activerecord.errors.messages.not_a_list'))
            return false
          end

          true
        end
      end
    end
  end
end
