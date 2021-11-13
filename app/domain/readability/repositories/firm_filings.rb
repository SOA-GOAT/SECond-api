# frozen_string_literal: true

module SECond
  # Maps over local and remote git repo infrastructure
  class FirmFiling
    class Errors
      NoFirmSubmissionFound = Class.new(StandardError)
      TooLargeToDownload = Class.new(StandardError)
      CannotOverwriteLocalFirmSubmission = Class.new(StandardError)
    end

    def initialize(repo, config = SECond::App.config)
      @repo = repo
      remote = Submission::RemoteFirmSubmission.new(@repo.http_url)
      @local = Submission::LocalFirmSubmission.new(remote, config.REPOSTORE_PATH)
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
      raise Errors::TooLargeToDownload if @repo.too_large?
      raise Errors::CannotOverwriteLocalFirmSubmission if exists_locally?

      @local.clone_remote { |line| yield line if block_given? }
    end
  end
end
