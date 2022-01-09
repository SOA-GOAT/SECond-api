# frozen_string_literal: true

module SECond
  module Entity
    # Entity for file contributions
    class FilingTextualAttribute
      include Mixins::WordFrequencyCalculator
      attr_reader :sentences
      attr_reader :filing_rdb

      def initialize(sentences:)
        @sentences = sentences
        @filing_rdb = filing_rdbscore
      end

      def filing_rdbscore
        score = Value::ReadabilityScore.new(@sentences)
        score.readability_score
      end

      def filing_sentiment
        score = Value::SentimentScore.new(@sentences)
        score.sentiment_score
      end

      def size
        @sentences.size
      end
    end
  end
end
