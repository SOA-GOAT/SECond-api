# frozen_string_literal: true

require 'sentiment_lib'
require 'words_counted'
require 'stopwords'

module SECond
  module Entity
    # Entity for file contributions
    class FilingTextualAttribute
      include Mixins::ReadabilityCalculator
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

      def size
        @sentences.size
      end

      def sentiment_score
        document = @sentences.join(' ')
        analyzer = SentimentLib::Analyzer.new(:strategy => SentimentLib::Analysis::Strategies::FinancialDictStrategy.new)
        analyzer.analyze(document).to_i
      end

      def word_frequency
        document = @sentences.join(' ')
        filter = Stopwords::Snowball::Filter.new "en"
        counter = WordsCounted.count(document, exclude: ->(t) { filter.stopword? t })
        counter.token_frequency[0..149].select { |term_frequency| term_frequency[0].length > 2}
      end
    end
  end
end
