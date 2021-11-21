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

      attr_reader :edgar_tenk_path

      def initialize(firm_filings, tenkstore_path)
        @firm_filings = firm_filings
        @cik = firm_filings[0].cik
        @edgar_tenk_path = [tenkstore_path, @cik].join('/')
      end

      def select_tenk
        @firm_filings.select { |filing| filing.form_type.include? '10-K' }
      end

      def download_tenk
        api = Edgar::EdgarApi.new
        select_tenk.each do |tenk|
          api.download_submission_url(@cik, tenk.accession_number)
        end
        # @remote.local_clone(@edgar_tenk_path) { |line| yield line if block_given? }
        self
      end

      def exists?
        Dir.exist? @edgar_tenk_path
      end

      # Deliberately :reek:MissingSafeMethod delete
      def delete!
        FileUtils.rm_rf(@edgar_tenk_path)
      end

      private

      def raise_unless_setup
        raise Errors::InvalidLocalFirmSubmission unless exists?
      end

      def wipe
        FileUtils.rm_rf @edgar_tenk_path
      end
    end
  end
end
