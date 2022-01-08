# frozen_string_literal: true

module SECond
  module Value
    # Value of readability score shared by filings or firms
    class ReadabilityScore < SimpleDelegator
      def initialize(sentences)
        super @sentences = sentences
      end

      # def add_score(sentence)
      #   self[sentence] += sentence.readability_score
      # end

      def readability_score
        (aver_sentence_length**2) / 35
      end

      def aver_sentence_length
        total = 0
        @sentences.each { |sentence| total += sentence.size } # size should be sentence_length
        total / @sentences.size
      end
    end
  end
end
