# frozen_string_literal: true

require 'sentiment_lib'

module SECond
  module Entity
    # Entity for file contributions
    class FilingReadability
      include Mixins::ReadabilityCalculator
      attr_reader :sentences
      attr_reader :filing_rdb

      def initialize(sentences:)
        # @file_path = Value::FilePath.new(file_path)
        @sentences = sentences
        @filing_rdb = filing_rdbscore
      end

      def filing_rdbscore
        score = Value::ReadabilityScore.new(@sentences)
        score.readability_score
      end

      def size
        @sentences.size
      end

      def sentiment_score
        document = @sentences.join(' ')
        analyzer = SentimentLib::Analyzer.new(:strategy => SentimentLib::Analysis::Strategies::FinancialDictStrategy.new)
        analyzer.analyze(document)
      end
    end
  end
end
