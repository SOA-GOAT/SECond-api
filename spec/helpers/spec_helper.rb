# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../init'

CIK = '0000320193'
FIRM_NAME = 'Apple Inc.'
CORRECT = YAML.safe_load(File.read('spec/fixtures/edgar_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'edgar_api'

# Helper method for acceptance tests
def homepage
  SECond::App.config.APP_HOST
end
