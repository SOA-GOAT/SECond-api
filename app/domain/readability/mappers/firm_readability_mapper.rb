# frozen_string_literal: true

require_relative 'filing_readability_mapper'

module SECond
  module Mapper
    # Summarizes readability for an entire firm
    class FirmReadability
      attr_reader :filings

      def initialize(filings)
        @filings = filings
      end

      def build_entity
        Entity::FirmReadability.new(
          filings: filings_summaries,
        )
      end

      def filings_summaries
        @filings.map do |filing|
          Mapper::FilingReadability.new(filing).build_entity
        end
      end
    end
  end
end
