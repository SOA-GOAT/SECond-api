# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/edgar_api'
require_relative 'spec_helper'

describe 'Tests Edgar API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after { VCR.eject_cassette }

  describe 'Submission information' do
    it 'HAPPY: should provide correct submission attributes' do
      submission = SECond::EdgarApi.new.submission(CIK)
      _(submission.sic).must_equal CORRECT['sic']
      _(submission.sic_description).must_equal CORRECT['sicDescription']
      _(submission.name).must_equal CORRECT['name']
      _(submission.tickers).must_equal CORRECT['tickers']
    end
    it 'SAD: should raise exception on incorrect submission' do
      _(proc do
        SECond::EdgarApi.new.submission('0000000000')
      end).must_raise SECond::EdgarApi::Response::NotFound
    end
  end
end
