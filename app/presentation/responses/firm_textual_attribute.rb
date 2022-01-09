# frozen_string_literal: true

module SECond
  module Response
    # Readability for a filing of a filing
    FirmTextualAttribute = Struct.new(:filings_textual_attribute, :aver_firm_rdb, :aver_firm_sentiment)
  end
end
