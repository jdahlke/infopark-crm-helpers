module Crm
  module Helpers
    module Finders
      def self.included(base)
        base.extend self
      end

      def find(id_or_ids)
        case id_or_ids
        when String
          crm_object = crm_class.find(id_or_ids)
          return nil if crm_object.blank?

          new(crm_object.attributes)
        when Array
          crm_objects = Crm.find(id_or_ids).to_a
          rejected_crm_objects = crm_objects.reject { |crm_object| crm_object.is_a?(crm_class) }
          raise Errors::ResourceNotFound.new("Not of type #{crm_class.name}", rejected_crm_objects.map(&:id)) if rejected_crm_objects.present?

          crm_objects.map { |crm_object| new(crm_object.attributes) }
        end
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
