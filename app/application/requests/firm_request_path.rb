# frozen_string_literal: true

module SECond
  module Request
    # Application value for the path of a requested frim
    class FirmPath
      def initialize(cik, request)
        @cik = cik
        @request = request
        @path = request.remaining_path
      end
  
      attr_reader :cik
    end
  end
end
  