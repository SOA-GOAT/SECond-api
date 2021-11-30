# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'filing_representer'

# Represents essential Repo information for API output
module SECond
  module Representer
    # Represent a Project entity as Json
    class Firm < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :id
      property :cik
      property :sic
      property :sic_description
      property :name
      property :tickers
      collection :filings, extend: Representer::Filing, class: OpenStruct

      link :self do
        "#{App.config.API_HOST}/api/v1/firms/#{cik}"
      end

      private

      def firm_name
        represented.name
      end

      def firm_cik
        represented.cik
      end
    end
  end
end
