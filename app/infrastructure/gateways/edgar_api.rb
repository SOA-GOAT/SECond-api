# frozen_string_literal: true

require 'http'
# require_relative 'firm'

module SECond
  module Edgar
    # Library for EDGAR API
    class EdgarApi
      def initialize; end

      def firm_data(cik)
        Request.new.firm(cik).parse
      end

      def submission_data(cik)
        raw_data = Request.new.firm(cik).parse

        # attribute of recent filings
        filings = raw_data['filings']
        recent = filings['recent']

        # get attribute of old filings
        old_files = filings['files']
        old_files.each do |files|
          filename = files['name']
          old = Request.new.get("https://data.sec.gov/submissions/#{filename}").parse
          recent.merge!(old) { |_key, old_value, new_value| old_value + new_value }
        end
        recent
      end

      # Sends out HTTP requests to Edgar
      class Request
        # Rubocop: Do not .freeze immutable object
        SUBMISSION_PATH = 'https://data.sec.gov/submissions/'
        def initialize; end

        def firm(cik)
          cik = format('%010d', cik.to_i)
          get("#{SUBMISSION_PATH}CIK#{cik}.json")
        end

        def get(url)
          http_response =
            HTTP.headers('Accept' => '*/*',
                         'Connection' => 'keep-alive').get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from Edgar with success/error reporting
      class Response < SimpleDelegator
        # The Errors class is responsible for 401 Unauthorized
        Unauthorized = Class.new(StandardError)
        # The Errors class is responsible for 404 NotFound
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          404 => NotFound
        }.freeze

        def successful?
          # HTTP_ERROR.keys.include?(code) ? false : true
          !HTTP_ERROR.keys.include?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
