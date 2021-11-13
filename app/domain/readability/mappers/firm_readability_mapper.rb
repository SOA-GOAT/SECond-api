# frozen_string_literal: true

require_relative 'filing_readability_mapper'

module SECond
  module Mapper
    # Summarizes contributions for an entire folder
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
        @contributions_reports.map do |file_report|
          Mapper::FilingReadability.new(file_report).build_entity
        end
      end
    end
  end
end
