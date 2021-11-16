# frozen_string_literal: true

module SECond
  module Mapper
    # Git contributions parsing and reporting services
    class Readability
      def initialize
      end

      def for_firm(cik) # To be rename...
        edgar_firm = Repository::For.klass(Entity::Firm).find_cik(cik)
        tenk_filings = edgar_firm.filings.select { |filing| filing.form_type.include? "10-K"} 
        
        Mapper::FirmReadability.new(tenk_filings).build_entity
      end
    end
  end
end
