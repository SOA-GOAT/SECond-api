# frozen_string_literal: true

require 'dry/transaction'

module SECond
  module Service
    # Analyzes contributions to a project
    class InspectFirm
      include Dry::Transaction

      step :ensure_watched_firm
      step :retrieve_remote_firm
      step :download_remote
      step :calculate_readability

      private

      def ensure_watched_firm(input)
        if input[:watched_list].include? input[:requested]
          Success(input)
        else
          Failure('Please first request this firm to be added to your list')
        end
      end

      def retrieve_remote_firm(input)
        input[:firm] = Repository::For.klass(Entity::Firm).find_cik(input[:requested])

        input[:firm] ? Success(input) : Failure('Firm not found')
      rescue StandardError
        Failure('Having trouble accessing the database')
      end

      def download_remote(input)
        firm_filings = FirmFiling.new(input[:firm])
        firm_filings.download! unless firm_filings.exists_locally?

        Success(input.merge(firm_filings: firm_filings))
      rescue StandardError
        puts error.backtrace.join("\n")
        Failure('Could not download this firms filings')
      end

      def calculate_readability(input)
        input[:firm_rdb] = Mapper::Readability
          .new.for_firm(input[:requested])
        Success(input)
      rescue StandardError
        Failure('Could not find that firm readability')
      end
    end
  end
end
