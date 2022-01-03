# frozen_string_literal: true

require 'nokogiri'

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

      def split_into_sentences
        # read a filing
        path = 'app/infrastructure/edgar/10Kstore'
        filing_path = "#{path}/#{@filing.cik}/#{@filing.accession_number}.txt"
        file = File.open(filing_path)

        # convert fiiling into sentnces
        content = file.read
        document = Nokogiri::HTML(content).text

        sentences = document.split(/(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?|\!)\s/)
      end

      def sentences_summaries
        sentences = split_into_sentences
        sentences.each do |sentence|
          Mapper::SentenceReadability.new(sentence).to_entity
        end
      end
    end
  end
end
