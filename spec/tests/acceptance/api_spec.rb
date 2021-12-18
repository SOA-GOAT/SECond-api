# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require 'rack/test'

def app
  SECond::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_edgar
    DatabaseHelper.wipe_database
    SECond::Repository::FilingStore.wipe
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Inspect firm route' do
    it 'should be able to inspect a firm route' do
      SECond::Service::AddFirm.new.call(
        firm_cik: CIK
      )

      get "/api/v1/firm/#{CIK}"
      _(last_response.status).must_equal 202

      5.times { sleep(15) and print('_') }

      get "/api/v1/firm/#{CIK}"
      _(last_response.status).must_equal 200
      # firm_info = JSON.parse last_response.body
      # _(firm_info.keys.sort).must_equal %w[folder firm]
      # _(firm_info['firm']['name']).must_equal firm_NAME
      # _(firm_info['firm']['owner']['username']).must_equal USERNAME
      # _(firm_info['firm']['contributors'].count).must_equal 3
      # _(firm_info['folder']['path']).must_equal ''
      # _(firm_info['folder']['subfolders'].count).must_equal 10
      # _(firm_info['folder']['line_count']).must_equal 1450
      # _(firm_info['folder']['base_files'].count).must_equal 2
    end

    it 'should be report error for an invalid firm' do
      #  SECond::Service::AddFirm.new.call(
      #    firm_cik: '0000000000'
      #  )

      get "/api/v1/firm/#{BAD_CIK}"
      _(last_response.status).must_equal 404
      _(JSON.parse(last_response.body)['status']).must_include 'not'
    end
  end

  describe 'Add firms route' do
    it 'should be able to add a project' do
      post "api/v1/firm/#{CIK}"

      _(last_response.status).must_equal 201

      firm = JSON.parse last_response.body
      _(firm['name']).must_equal FIRM_NAME

      firm = SECond::Representer::Firm.new(
        SECond::Representer::OpenStructWithLinks.new
      ).from_json last_response.body
      _(firm.links['self'].href).must_include 'firm'
    end

    it 'should report error for invalid firm' do
      post 'api/v1/firm/0000000000'

      _(last_response.status).must_equal 404

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'not'
    end
  end

  describe 'Get firms list' do
    it 'should successfully return firm lists' do
      SECond::Service::AddFirm.new.call(
        firm_cik: CIK
      )

      # list = ["#{CIK}"]
      list = [CIK.to_s]
      encoded_list = SECond::Request::EncodedFirmList.to_encoded(list)

      get "/api/v1/firm?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      firms = response['firms']
      _(firms.count).must_equal 1
      firm = firms.first
      _(firm['name']).must_equal FIRM_NAME
      # _(firm['owner']['username']).must_equal USERNAME
      # _(firm['contributors'].count).must_equal 3
    end

    it 'should return empty lists if none found' do
      list = ['0000000000']
      encoded_list = SECond::Request::EncodedFirmList.to_encoded(list)

      get "/api/v1/firm?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      firms = response['firms']
      _(firms).must_be_kind_of Array
      _(firms.count).must_equal 0
    end

    it 'should return error if not list provided' do
      get '/api/v1/firm'
      _(last_response.status).must_equal 400

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'list'
    end
  end
end
