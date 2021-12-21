# frozen_string_literal: true

require_relative '../app/domain/init'
require_relative '../app/application/requests/init'
require_relative '../app/infrastructure/git/init'
require_relative '../app/presentation/representers/init'
require_relative 'download_monitor'
require_relative 'job_reporter'

require 'figaro'
require 'shoryuken'

# Shoryuken worker class to download filings in parallel
module EdgarDownload
  class Worker
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
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.DOWNLOAD_QUEUE_URL, auto_delete: true

    def perform(_sqs_msg, request)
      job = JobReporter.new(request, Worker.config)

      job.report(DownloadMonitor.starting_percent)
      SECond::FirmFiling.new(job.firm, Worker.config).download! do |line|
        job.report DownloadMonitor.progress(line)
      end

      # Keep sending finished status to any latecoming subscribers
      job.report_each_second(5) { DownloadMonitor.finished_percent }
    rescue SECond::FirmFiling::Errors::CannotOverwriteLocalFirmSubmission
      puts 'DOWNLOAD EXISTS -- ignoring request'
    end
  end
end
