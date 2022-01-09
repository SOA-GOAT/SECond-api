# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

# require_relative 'contributor'

module SECond
  module Entity
    # Entity for a sentence in filing
    class SentenceTextualAttribute
      attr_reader :sentence

      def initialize(sentence:)
        @sentence = sentence
      end

      def sentence_length
        @sentence.size
      end
    end
  end
end
