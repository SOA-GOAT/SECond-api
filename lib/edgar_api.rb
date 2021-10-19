# frozen_string_literal: true

require 'http'
require_relative 'firm'

module SECond
  # Library for EDGAR API
  class EdgarApi
    API_ROOT = 'https://data.sec.gov'

    module Errors
      # The Errors class is responsible for 404 NotFound
      class NotFound < StandardError; end
      # The Errors class is responsible for 401 Unauthorized
      class Unauthorized < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize; end

    def firm(cik)
      firm_response = Request.new(API_ROOT)
                             .firms(cik).parse
      Firm.new(firm_response)
    rescue JSON::ParserError
      raise(HTTP_ERROR[404])
    end

    # Sends out HTTP requests to Github
    class Request
      def initialize(resource_root)
        @resource_root = resource_root
      end

      def firms(cik)
        get("#{@resource_root}/submissions/CIK#{cik}.json")
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

    # Decorates HTTP responses from Github with success/error reporting
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
        HTTP_ERROR.keys.include?(code) ? false : true
      end

      def error
        HTTP_ERROR[code]
      end
    end
  end
end
