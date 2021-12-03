# frozen_string_literal: true

require 'dry/transaction'

module SECond
  module Service
    # Transaction to store firm from Edgar API to database
    class AddFirm
      include Dry::Transaction

      step :format_cik
      step :find_firm
      step :store_firm

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      EG_NOT_FOUND_MSG = 'Could not find that firm on Edgar'
      CIK_REGEX = /^\d{,10}$/

      def format_cik(input)
        if CIK_REGEX.match?(input[:firm_cik])
          firm_cik = format('%010d', input[:firm_cik].to_i)
          input[:firm_cik] = firm_cik
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :bad_request, message: "CIK #{input.errors.messages.first}"))
        end
      end

      def find_firm(input)
        firm = firm_in_database(input)
        puts firm
        if (firm)
          input[:local_firm] = firm
        else
          input[:remote_firm] = firm_from_edgar(input)
        end
        Success(input)
      rescue StandardError => err
        puts 'what are doing ERR @@@'
        Failure(Response::ApiResult.new(status: :not_found, message: err.to_s))
      end

      def store_firm(input)
        firm =
          if (new_firm = input[:remote_firm])
            Repository::For.entity(new_firm).create(new_firm)
          else
            input[:local_firm]
          end
        Success(Response::ApiResult.new(status: :created, message: firm))
      rescue StandardError => err
        puts err.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end

      # following are support methods that other services could use

      def firm_from_edgar(input)
        Edgar::FirmMapper.new.find(input[:firm_cik])
      rescue StandardError
        raise EG_NOT_FOUND_MSG
      end

      def firm_in_database(input)
        Repository::For.klass(Entity::Firm).find_cik(input[:firm_cik]) 
      end
    end
  end
end
