# frozen_string_literal: true

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

  after do
    VCR.eject_cassette
  end

  describe 'Firm information' do
    it 'HAPPY: should provide correct firm attributes' do
      firm = SECond::Edgar::FirmMapper.new.find(CIK)
      _(firm.sic).must_equal CORRECT['sic']
      _(firm.sic_description).must_equal CORRECT['sicDescription']
      _(firm.name).must_equal CORRECT['name']
      _(firm.tickers).must_equal CORRECT['tickers']
    end
    it 'SAD: should raise exception on incorrect firm' do
      _(proc do
        SECond::Edgar::FirmMapper.new.find('0000000000')
      end).must_raise SECond::Edgar::EdgarApi::Response::NotFound
    end
  end
end
