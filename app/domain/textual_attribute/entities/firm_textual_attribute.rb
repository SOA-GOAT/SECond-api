# frozen_string_literal: true

module SECond
  module Entity
    # Aggregate root for contributions domain
    class FirmTextualAttribute < SimpleDelegator
      include Mixins::WordFrequencyCalculator

      attr_reader :filings
      attr_reader :aver_firm_rdb
      attr_reader :aver_firm_sentiment

      def initialize(filings:)
        # super(Types::HashedArrays.new)
        super @filings = filings
        @aver_firm_rdb = aver_firm_readability
        @aver_firm_sentiment = aver_firm_sentiment
      end

      # :reek:FeatureEnvy
      def aver_firm_readability
        scores = @filings.map(&:filing_rdbscore)
        scores.sum / scores.size
      end

      def aver_firm_sentiment
        scores = @filings.map(&:filing_sentiment)
        scores.sum / scores.size
      end

      def sentences
        @filings.map(&:sentences).reduce(:+)
      end

      def size
        @filings.size
      end

      # private
      # def assign_base_files
      # def subfolder_files
    end
  end
end
