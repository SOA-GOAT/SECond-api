# frozen_string_literal: true

module SECond
  # Model for Firm
  class Firm
    def initialize(firm_data)
      @firm = firm_data
    end

    def sic
      @firm['sic']
    end

    def sic_description
      @firm['sicDescription']
    end

    def name
      @firm['name']
    end

    def tickers
      @firm['tickers']
    end
  end
end
