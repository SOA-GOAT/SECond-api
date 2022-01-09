# frozen_string_literal: true

module SECond
  module Mixins
    # readability calculation methods
    module ReadabilityCalculator
      def word_count
        sentences.map(&:sentence_length).sum
      end

      def aver_word_count
        return 0 if size.zero? # for files with no creditable lines

        word_count / size
      end
    end
  end
end
