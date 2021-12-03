# frozen_string_literal: true

require 'dry/transaction'

module SECond
  module Service
    # Analyzes contributions to a project
    class InspectFirm
      include Dry::Transaction

      step :retrieve_remote_firm
      step :download_remote
      step :calculate_readability

      private

      NO_FIRM_ERR = 'Firm not found'
      DB_ERR = 'Having trouble accessing the database'
      DOWNLOAD_ERR = 'Could not download this firm'
      NO_FILING_ERR = 'Could not find that filing'

      def retrieve_remote_firm(input)
        input[:firm] = Repository::For.klass(Entity::Firm).find_cik(input[:requested].firm_cik)

        if input[:firm]
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :not_found, message: NO_FIRM_ERR))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def download_remote(input)
        firm_filings = FirmFiling.new(input[:firm])
        firm_filings.download! unless firm_filings.exists_locally?

        Success(input.merge(firm_filings: firm_filings))
      rescue StandardError
        puts error.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DOWNLOAD_ERR))
      end

      def calculate_readability(input)
        input[:firm_rdb] = Mapper::Readability
          .new.for_firm(input[:requested].firm_cik)

        Response::FirmReadability.new(input[:firm_rdb])
          .then do |rdb|
            Success(Response::ApiResult.new(status: :ok, message: rdb))
          end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: NO_FILING_ERR))
      end
    end
  end
end
