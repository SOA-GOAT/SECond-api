# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module SECond
  module Representer
    # Represents essential Filing information for API output
    # USAGE:
    #   filing = Database::FilingOrm.find(1)
    #   Representer::Filing.new(filing).to_json
    class DownloadFiling < Roar::Decorator
      include Roar::JSON

      property :id
      property :cik
      property :accession_number
      property :form_type
    end
  end
end
