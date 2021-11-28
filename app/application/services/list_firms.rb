# frozen_string_literal: true

require 'dry/monads'

module SECond
  module Service
    # Retrieves array of all listed firm entities
    class ListFirms
      include Dry::Monads::Result::Mixin

      def call(firms_list)
        firms = Repository::For.klass(Entity::Firm)
          .find_ciks(firms_list)

        Success(firms)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
