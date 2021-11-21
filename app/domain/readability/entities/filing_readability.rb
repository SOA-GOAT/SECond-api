# frozen_string_literal: true

module SECond
  module Entity
    # Entity for file contributions
    class FilingReadability
      include Mixins::ReadabilityCalculator
      # paragraphs 是 filing 有幾段
      attr_reader :sentences

      def initialize(sentences:)
        # @file_path = Value::FilePath.new(file_path)
        @sentences = sentences
      end

      def filing_rdbscore
        score = Value::ReadabilityScore.new(@sentences)
        score.readability_score
      end

      def size
        @sentences.size
      end
    end
  end
end
