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

      def format_cik(input)
        if input.success?
          firm_cik = format('%010d', input[:firm_cik].to_i)
          Success(firm_cik: firm_cik)
        else
          Failure("CIK #{input.errors.messages.first}")
        end
      end

      def find_firm(input)
        if (firm = firm_in_database(input))
          input[:local_firm] = firm
        else
          input[:remote_firm] = firm_from_edgar(input)
        end
        Success(input)
      rescue StandardError
        Failure(error.to_s)
      end

      def store_firm(input)
        firm =
          if (new_firm = input[:remote_firm])
            Repository::For.entity(new_firm).create(new_firm)
          else
            input[:local_firm]
          end
        Success(firm)
      rescue StandardError
        puts error.backtrace.join("\n")
        Failure('Having trouble accessing the database')
      end

      # following are support methods that other services could use

      def firm_from_edgar(input)
        Edgar::FirmMapper.new.find(input[:firm_cik])
      rescue StandardError
        raise 'Could not find that firm on Edgar'
      end

      def firm_in_database(input)
        Repository::For.klass(Entity::Firm).find_cik(input[:firm_cik])
      end
    end
  end
end
