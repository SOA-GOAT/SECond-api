# frozen_string_literal: true

module SECond
  module Value
    # Value of credits shared by contributors for file, files, or folder
    class ReadabilityScore < SimpleDelegator
      # rubocop:disable Style/RedundantSelf
      def initialize
        #  super(Types::HashedIntegers.new)
      end

      # def add_score(sentence)
      #   self[sentence] += sentence.readability_score
      # end
      
      def readability_score
        aver_sentence_length^2 / 35
      end

      def aver_sentence_length
        total = 0
        sentences.each {|sentence| total += sentence.sentence_length}
        total / sentences.size
      end
      # def +(other)
      #   (self.contributors + other.contributors).uniq
      #     .each_with_object(Value::CreditShare.new) do |contributor, total|
      #       total[contributor] = self[contributor] + other[contributor]
      #     end
      # end

      # rubocop:enable Style/RedundantSelf
    end
  end
end