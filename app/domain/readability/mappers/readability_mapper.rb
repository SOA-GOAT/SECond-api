# frozen_string_literal: true

module SECond
  module Mapper
    # Git contributions parsing and reporting services
    class ReadabilityScore
      def initialize; end

      # To be rename...
      def for_firm(cik)
        edgar_firm = Repository::For.klass(Entity::Firm).find_cik(cik)
        tenk_filings = edgar_firm.filings.select { |filing| filing.form_type.include? '10-K' }
        Mapper::FirmReadability.new(tenk_filings).build_entity
      end
    end
  end
end
