# frozen_string_literal: true

module Crm
  module Helpers
    module Validators
      class CrmListValidator < CrmEachValidator
        def validate_each(record, attribute, value)
          return if value.is_a?(Array)

          record.errors.add(attribute, I18n.t('activerecord.errors.messages.not_a_list'))
        end
      end
    end
  end
end
