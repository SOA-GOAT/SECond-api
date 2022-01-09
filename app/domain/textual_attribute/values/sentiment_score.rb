# frozen_string_literal: true

require 'sentiment_lib'

module SECond
  module Value
    # Value of Sentiment score shared by filings or firms
    class SentimentScore < SimpleDelegator
      def initialize(sentences)
        super @sentences = sentences
      end

      def sentiment_score
        document = @sentences.join(' ')
        analyzer = SentimentLib::Analyzer.new(:strategy => SentimentLib::Analysis::Strategies::FinancialDictStrategy.new)
        analyzer.analyze(document).to_i
      end
    end
  end
end
