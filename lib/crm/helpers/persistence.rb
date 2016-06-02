module Crm
  module Helpers
    module Persistence
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def create(attributes = {})
          instance = new(attributes)
          return instance if instance.invalid?

          instance.save!
          instance
        end
      end

      def save
        update
      end

      def save!
        update!
      end

      def update(attributes = {})
        assign_attributes(attributes)
        return false if invalid?

        persist
      end

      def update!(attributes = {})
        assign_attributes(attributes)
        raise "#{self.class.name} object is invalid." if invalid?

        persist
      end

      def destroy
        crm_object.destroy
        self
      end

      def persist
        return false if invalid?

        @crm_object = if id.blank?
                        self.class.crm_class.create(crm_attributes)
                      else
                        crm_object.update(crm_attributes)
                      end
        assign_attributes(crm_object.attributes)
        true
      end

      protected

      def crm_object
        return nil if id.blank?
        @crm_object ||= self.class.crm_class.find(id)
      end
    end
  end
end
