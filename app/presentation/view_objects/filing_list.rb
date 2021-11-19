# frozen_string_literal: true

require_relative 'filing'

module Views
  # View for a a list of filing entities
  class FilingsList
    def initialize(filings)
      @filings = filings.map.with_index { |filing, i| Firm.new(filing, i) }
    end

    def each
      @filings.each do |filing|
        yield filing
      end
    end

    def any?
      @filings.any?
    end
  end
end