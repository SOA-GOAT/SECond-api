# frozen_string_literal: true

module Views
  # View for a single filing entity
  class Filling
    def initialize(filing, index = nil)
      @filing = filing
      @index = index
    end

    def entity
      @filing
    end

    def index_str
      "filling[#{@index}]"
    end

    def cik
      @filing.cik
    end

    def accession_number
      @filing.accession_number
    end

    def form_type
      @filing.form_type
    end

    def filing_date
      @filing.filing_date
    end

    def reporting_date
      @filing.reporting_date
    end

    def primary_document
      @filing.primary_document
    end

    def size
      @filing.size
    end
  end
end
