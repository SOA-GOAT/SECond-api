# frozen_string_literal: true

# require_relative 'blame_contributor'

module SECond
  module Mapper
    # Summarizes a single file's contributions by team members
    class FilingReadability
      def initialize(filing)
        @filing = filing
      end

      def build_entity
        Entity::FilingReadability.new(
          sentences: sentences_summaries
        )
      end

      private

      def get_sentences
        # read a filing
        path = 'app/infrastructure/edgar/10Kstore'
        filing_path = "#{path}/#{@filing.cik}/#{@filing.accession_number}.txt"
        file = File.open(filing_path)

        # convert fiiling into sentnces
        content = file.read
        content.split(/\.|\?|\!/)
      end

      def sentences_summaries(line_reports)
        sentences = get_sentences
        sentences.each do |sentence|
          SentenceReadability.new(sentence).build_entity
        end
      end
    end
  end
end
