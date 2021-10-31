# frozen_string_literal: true

require 'http'
require 'yaml'
require_relative 'edgar_api'

edgar_results = {}

## HAPPY firm request
firm = SECond::EdgarApi.new.firm('0000320193')

edgar_results['sic'] = firm['sic']
# should be 3571

edgar_results['sicDescription'] = firm['sicDescription']
# should be Electronic Computers

edgar_results['name'] = firm['name']
# should be Apple Inc.

edgar_results['tickers'] = firm['tickers']
# should be a list ["AAPL"]

## BAD firm request
SECond::EdgarApi.new.firm('0000000000')

File.write('spec/fixtures/edgar_results.yml', edgar_results.to_yaml)
