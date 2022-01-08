# frozen_string_literal: true

module SECond
  module Mapper
    # Summarizes a single sentenece's textual attribute
    class SentenceTextualAttribute
      def initialize(sentence)
        @sentence = sentence
      end

      def to_entity
        Entity::SentenceTextualAttribute.new(
          sentence: @sentence
        )
      end
    end
  end
end
