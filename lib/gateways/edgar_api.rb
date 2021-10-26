# frozen_string_literal: true

require 'http'
# require_relative 'firm'

module SECond
  module Edgar  
    # Library for EDGAR API
    class EdgarApi
      
      def initialize; end

      def submission_data(cik)
      #   firm_response = Request.new(API_ROOT)
      #                         .firms(cik).parse
      #   Firm.new(firm_response) # self causes error
      # rescue JSON::ParserError
      #   raise(HTTP_ERROR[404])
        Request.new().submission(cik).parse
      end

      # Sends out HTTP requests to Edgar
      class Request
        SUBMISSION_PATH = 'https://data.sec.gov/submissions/'.freeze
        def initialize; end

        def submission(cik)
          get("#{SUBMISSION_PATH}CIK#{cik}.json")
        end

        def get(url)
          http_response =
            HTTP.headers('Accept' => '*/*',
                        'Connection' => 'keep-alive')
                .get(url)

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
