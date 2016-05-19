module Crm
  module Helpers
    module Validations
      def self.included(base)
        base.extend ActiveModel::Naming
        base.include ActiveModel::Conversion
        base.include ActiveModel::Validations
        base.include Crm::Helpers::Attributes

        base.extend ClassMethods
      end

      module ClassMethods
        def mandatory_crm_attributes
          crm_attributes.select { |_, definition| definition[:mandatory] }.keys.sort.map(&:to_sym)
        end

        def represents_crm_type(type)
          super
          crm_attr_accessor(*mandatory_crm_attributes)
        end

        def validates_crm_type
          validates_presence_of(*mandatory_crm_attributes) if mandatory_crm_attributes.present?
          if crm_attr_readers.present?
            validates_with Crm::Helpers::Validators::CrmAttributeValidator, attributes: crm_attr_readers
          end
        end
      end
    end
  end
end
