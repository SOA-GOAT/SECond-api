# frozen_string_literal: true

require_relative 'progress_publisher'

module EdgarDownload
  # Reports job progress to client
  class JobReporter
    attr_accessor :firm

    def initialize(request_json, config)
      download_request = SECond::Representer::DownloadRequest
        .new(OpenStruct.new)
        .from_json(request_json)

      @firm = download_request.firm
      @publisher = ProgressPublisher.new(config, download_request.id)
    end

    def report(msg)
      @publisher.publish msg
    end

    def report_each_second(seconds, &operation)
      seconds.times do
        sleep(1)
        report(operation.call)
      end
    end
  end
end