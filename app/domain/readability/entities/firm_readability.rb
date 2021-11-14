# frozen_string_literal: true

module SECond
  module Entity
    # Aggregate root for contributions domain
    class FirmReadability < SimpleDelegator
      include Mixins::ReadabilityCalculator

      attr_reader :filings

      def initialize(filings:)
        # super(Types::HashedArrays.new)

        @filings = filings
      #   @base_files = assign_base_files
      #   @subfolders = subfolder_contributions
      end

      def aver_firm_readability
        scores = @filings.map(&:filing_rdbscore)
        scores.sum / scores.size
      end

      def sentences
        @filings.map(&:sentences).reduce(:+)
      end

      def size
        @filings.size
      end

      # def credit_share
      #   @credit_share ||= files.map(&:credit_share).reduce(&:+)
      # end

      # def contributors
      #   credit_share.keys
      # end

      # def folder_path
      #   path.empty? ? path : "#{path}/"
      # end

      # private

      # def assign_base_files
      #   files
      #     .select { |file| file.file_path.directory == folder_path }
      #     .each   { |base_file| self[base_file.file_path.filename] = base_file }
      # end

      # def nested_files
      #   files - base_files
      # end

      # def subfolder_files
      #   nested_files
      #     .each_with_object(Types::HashedArrays.new) do |nested, lookup|
      #       subfolder = nested.file_path.folder_after(folder_path)
      #       lookup[subfolder] << nested
      #     end
      # end

      # def subfolder_contributions
      #   subfolder_files.map do |folder_name, folder_files|
      #     FolderContributions.new(path: folder_name, files: folder_files)
      #   end.each { |folder| self[folder.path] = folder }
      # end
    end
  end
end