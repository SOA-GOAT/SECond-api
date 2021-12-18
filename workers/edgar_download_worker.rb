# frozen_string_literal: true

require_relative '../init'

require 'figaro'
require 'shoryuken'

# Shoryuken worker class to download filings in parallel
class EdgarDownloadWorker
  # Environment variables setup
  Figaro.application = Figaro::Application.new(
    environment: ENV['RACK_ENV'] || 'development',
    path: File.expand_path('config/secrets.yml')
  )
  Figaro.load
  def self.config() = Figaro.env

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.DOWNLOAD_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, request)
    firm = SECond::Representer::Firm
      .new(OpenStruct.new).from_json(request)
    SECond::FirmFiling.new(firm).download!
  rescue SECond::FirmFiling::Errors::CannotOverwriteLocalFirmSubmission
    puts 'DOWNLOAD EXISTS -- ignoring request'
  end
end
