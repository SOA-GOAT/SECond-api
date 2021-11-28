# frozen_string_literal: true

require 'dry-validation'

module SECond
  module Forms
    # Valdate input form for firm cik search
    class NewFirm < Dry::Validation::Contract
      CIK_REGEX = %r{/^\d{,10}$/}

      params do
        required(:firm_cik).filled(:string)
      end

      rule(:firm_cik) do
        key.failure('is an invalid cik for a Edgar firm') unless CIK_REGEX.match?(value)
      end
    end
  end
end
