module Crm
  module Helpers
    module Finders
      def self.included(base)
        base.extend self
      end

      def find(id)
        crm_object = crm_class.find(id)
        return nil if crm_object.blank?

        new(crm_object.attributes)
      end

      def find_by_query(query, options = {})
        limit = options[:limit] || 50
        sort_order = options[:sort_order] || 'desc'

        crm_class.query(query).limit(limit).sort_order(sort_order).to_a.map do |crm_object|
          new(crm_object.attributes)
        end
      end
    end
  end
end
