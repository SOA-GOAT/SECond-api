# frozen_string_literal: true

require 'fileutils'

module SECond
  module Submission
    module Errors
      # Local submission not setup or invalid
      InvalidLocalFirmSubmission = Class.new(StandardError)
    end

    # Manage local Submission repository
    class LocalFirmSubmissions
      ONLY_FOLDERS = '**/'
      FILES_AND_FOLDERS = '**/*'

      attr_reader :edgar_10K_path

      def initialize(firm_filings, tenKstore_path)
        @firm_filings = firm_filings
        @cik = firm_filings[0].cik
        @edgar_10K_path = [tenKstore_path, @cik].join('/')
      end

      def select_10K
        @firm_filings.select { |filing| filing.form_type.include? '10-K' }
      end

      def download_10K
        api = Edgar::EdgarApi.new
        select_10K.each do |tenk|
          api.download_submission_url(@cik, tenk.accession_number)
        end
        # @remote.local_clone(@edgar_10K_path) { |line| yield line if block_given? }
        self
      end

      # def files
      #   raise_unless_setup

      #   @files ||= in_repo do
      #     Dir.glob(FILES_AND_FOLDERS).select do |path|
      #       File.file?(path) && (path =~ CODE_FILENAME_MATCH)
      #     end
      #   end
      # end

      # def in_repo(&block)
      #   raise_unless_setup
      #   Dir.chdir(@edgar_10K_path) { yield block }
      # end

      def exists?
        Dir.exist? @edgar_10K_path
      end

      # Deliberately :reek:MissingSafeMethod delete
      def delete!
        FileUtils.rm_rf(@edgar_10K_path)
      end

      private

      def raise_unless_setup
        raise Errors::InvalidLocalFirmSubmission unless exists?
      end

      def wipe
        FileUtils.rm_rf @edgar_10K_path
      end
    end
  end
end
