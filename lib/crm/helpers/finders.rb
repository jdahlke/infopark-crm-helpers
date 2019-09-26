# frozen_string_literal: true

module Crm
  module Helpers
    module Finders
      def self.included(base)
        base.extend self
      end

      def find(*args)
        wants_array = args.first.is_a?(Array)
        ids = args.flatten

        case ids.size
        when 0 then raise ArgumentError, 'Requires one or more IDs as argument.'
        when 1
          crm_object = find_one(ids.first)
          wants_array ? [crm_object].compact : crm_object
        else find_many(ids)
        end
      end

      def find_by_query(query, options = {})
        limit = options[:limit] || 50
        sort_order = options[:sort_order] || 'desc'

        result = crm_class.query(query).limit(limit).sort_order(sort_order).to_a
        result.map do |crm_object|
          new(crm_object.attributes)
        end
      end

      protected

      def find_one(id)
        crm_object = crm_class.find(id)
        return nil if crm_object.blank?

        new(crm_object.attributes)
      end

      def find_many(ids)
        crm_objects = Crm.find(ids).select do |crm_object|
          crm_object.is_a?(crm_class)
        end
        unknown_ids = ids - crm_objects.map(&:id)
        if unknown_ids.present?
          raise Errors::ResourceNotFound.new(
            'Items could not be found.', unknown_ids
          )
        end

        crm_objects.map { |crm_object| new(crm_object.attributes) }
      end
    end
  end
end
