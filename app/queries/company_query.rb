# frozen_string_literal: true

module Queries
  class CompanyQuery
    class << self
      ORDER_OPTIONS = %w[name cnpj].freeze
      ORDER_DIRECTION_OPTIONS = %w[asc desc].freeze

      def call(fields, order_by: 'name', direction: 'asc')
        raise_bad_request_exception unless direction.presence_in(ORDER_DIRECTION_OPTIONS)

        q = get_consult(fields)

        q.sort({ "#{order_by}": direction == 'asc' ? 1 : -1 }) if order_by.presence_in(ORDER_OPTIONS)
      end

      private

      def raise_bad_request_exception
        raise ::Exceptions::BadRequestException, ['Direction parameter must be asc or desc']
      end

      def get_consult(fields)
        return Company.all if fields.empty?

        Company.and(mount_where_clause(fields))
      end

      def mount_where_clause(fields)
        q = []
        fields.each { |key, value| q << ({ "#{map_field(key.to_sym)}": /#{value}/i }) }
        q
      end

      def map_field(field)
        {
          'locale': 'locale.name',
          'name': 'name',
          'cnpj': 'cnpj'
        }[field]
      end
    end
  end
end
