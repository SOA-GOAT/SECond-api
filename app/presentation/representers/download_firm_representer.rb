# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'download_filing_representer'

# Represents essential Firm information for API output
module SECond
  module Representer
    # Represent a Firm entity as Json
    class DownloadFirm < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :id
      property :cik
      collection :filings, extend: Representer::DownloadFiling, class: OpenStruct

      link :self do
        "/api/v1/firm/#{firm_cik}"
      end

      private

      def firm_cik
        represented.cik
      end
    end
  end
end
