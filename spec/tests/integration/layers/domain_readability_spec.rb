# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/database_helper'
require_relative '../../../helpers/vcr_helper'

describe 'Test Readability score Mapper and Gateway' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_edgar
    DatabaseHelper.wipe_database

    edgar_firm = SECond::Edgar::FirmMapper
      .new.find(CIK)

    @firm = SECond::Repository::For.entity(edgar_firm)
      .create(edgar_firm)

    @firm_filings = SECond::FirmFiling.new(@firm)
    @firm_filings.download! unless @firm_filings.exists_locally?

    @root = SECond::Mapper::Readability.new.for_firm(@firm.cik)
  end

  after do
    VcrHelper.eject_vcr
  end

  it 'HAPPY: should get readability summary for entire firm' do
    _(@root.size).must_equal 31
    _(@root.sentences.size).must_equal 1_413_718
    _(@root.aver_firm_readability).must_equal 617
  end

  it 'HAPPY: should get accurate readability summary for filings' do
    # averageforms = SECond::Mapper::Readability.new(@firm).for_firm('')
    filing = @root.filings[0]
    _(filing.size).must_equal 97_082
    _(filing.filing_rdbscore).must_equal 327
  end
end
