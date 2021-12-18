# frozen_string_literal: true

require 'dry/transaction'

module SECond
  module Service
    # Analyzes contributions to a project
    class InspectFirm
      include Dry::Transaction

      step :find_firm_details
      step :request_downloading_worker
      step :calculate_readability

      private

      NO_FIRM_ERR = 'Firm not found'
      DB_ERR = 'Having trouble accessing the database'
      DOWNLOAD_ERR = 'Could not download this firm'
      NO_FILING_ERR = 'Could not find that filing'
      PROCESSING_MSG = 'Processing the summary request'

      def find_firm_details(input)
        input[:firm] = Repository::For.klass(Entity::Firm).find_cik(input[:requested].firm_cik)

        if input[:firm]
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :not_found, message: NO_FIRM_ERR))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def request_downloading_worker(input)
        firm_filings = FirmFiling.new(input[:firm])
        return Success(input) if firm_filings.exists_locally?

        Messaging::Queue
          .new(App.config.DOWNLOAD_QUEUE_URL, App.config)
          .send(Representer::Firm.new(input[:firm]).to_json)

        Failure(Response::ApiResult.new(status: :processing, message: PROCESSING_MSG))
      rescue StandardError => e
        print_error(e)
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

      # Helper methods for steps

      def print_error(error)
        puts [error.inspect, error.backtrace].flatten.join("\n")
      end
    end
  end
end
