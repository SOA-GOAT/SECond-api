# frozen_string_literal: true

require_relative 'filing_textual_attribute_mapper'

module SECond
  module Mapper
    # Summarizes textual attribute for an entire firm
    class FirmTextualAttribute
      attr_reader :filings

      def initialize(filings)
        @filings = filings
      end

      def build_entity
        Entity::FirmTextualAttribute.new(
          filings: filings_summaries
        )
      end

      def filings_summaries
        @filings.map do |filing|
          Mapper::FilingTextualAttribute.new(filing).build_entity
        end
      end
    end
  end
end
