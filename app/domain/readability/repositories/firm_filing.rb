# frozen_string_literal: true

module SECond
  # Maps over local edgar submission infrastructure
  class FirmFiling
    class Errors
      NoFirmSubmissionFound = Class.new(StandardError)
      TooLargeToDownload = Class.new(StandardError)
      CannotOverwriteLocalFirmSubmission = Class.new(StandardError)
    end

    def initialize(firm, config)
      @firm = firm
      # remote = Submission::RemoteFirmSubmission.new(@firm.http_url)
      @local = Submission::LocalFirmSubmissions.new(firm.filings, config.TENKSTORE_PATH)
    end

    def local
      exists_locally? ? @local : raise(Errors::NoFirmSubmissionFound)
    end

    # Deliberately :reek:MissingSafeMethod for file system changes
    def delete!
      @local.delete!
    end

    def exists_locally?
      @local.exists?
    end

    # Deliberately :reek:MissingSafeMethod for file system changes
    def download!
      # raise Errors::TooLargeToDownload if @firm.too_large?
      raise Errors::CannotOverwriteLocalFirmSubmission if exists_locally?

      @local.download_tenk # { |line| yield line if block_given? }
    end
  end
end
