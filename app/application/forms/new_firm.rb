# frozen_string_literal: true

require 'dry-validation'

module SECond
  module Forms
    class NewFirm < Dry::Validation::Contract
      CIK_REGEX = %r{^\d{,10}$}.freeze

      params do
        required(:firm_cik).filled(:string)
      end

      rule(:firm_cik) do
        unless CIK_REGEX.match?(value)
          key.failure('is an invalid cik for a Edgar firm')
        end
      end
    end
  end
end
