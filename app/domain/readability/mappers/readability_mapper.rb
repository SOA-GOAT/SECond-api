# frozen_string_literal: true

module SECond
  module Mapper
    # Git contributions parsing and reporting services
    class Readability
      def initialize(cik)
        @cik = cik
      end

      def for_firm(cik)
        edgar_firm = Repository::For.klass(Entity::Firm).find_cik(cik)

        Mapper::FirmReadability.new(
          filings: edgar_firm.filings
        ).build_entity
      end
    end
  end
end
