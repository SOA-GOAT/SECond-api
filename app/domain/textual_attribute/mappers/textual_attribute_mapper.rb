# frozen_string_literal: true

module SECond
  module Mapper
    # Calculating textual attribute
    class TextualAttributeScore
      def initialize; end

      # To be rename...
      def for_firm(cik)
        edgar_firm = Repository::For.klass(Entity::Firm).find_cik(cik)
        tenk_filings = edgar_firm.filings.select { |filing| filing.form_type.include? '10-K' }
        Mapper::FirmTextualAttribute.new(tenk_filings).build_entity
      end
    end
  end
end
