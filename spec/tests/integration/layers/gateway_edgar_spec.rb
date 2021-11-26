# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests Edgar API library' do
  before do
    VcrHelper.configure_vcr_for_github
  end

  after do
    VcrHelper.eject_vcr
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

  ### ? ###
  # describe 'Submission information' do
  #   before do
  #     @firm = SECond::Edgar::FirmMapper.new.find(CIK)
  #   end

  #   it 'HAPPY: should recognize owner' do
  #     _(@firm.sic).must_be_kind_of SECond::Entity::Member
  #   end

  #   it 'HAPPY: should identify owner' do
  #     _(@firm.owner.username).wont_be_nil
  #     _(@firm.owner.username).must_equal CORRECT['owner']['login']
  #   end

  #   it 'HAPPY: should identify members' do
  #     members = @firm.contributors
  #     _(members.count).must_equal CORRECT['contributors'].count

  #     usernames = members.map(&:username)
  #     correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
  #     _(usernames).must_equal correct_usernames
  #   end
  # end
end
