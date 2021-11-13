# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

# require_relative 'contributor'

module SECond
  module Entity
    # Entity for a sentence in paragraph
    class SentenceReadability
      #  NOT_READABLE = 0
      #  READABLE = 1
      # length是一句話有幾個字，number是第幾句
      attr_reader :sentence

      def initialize(sentence:)
        @sentence = sentence
      end
      
      def sentence_length
        sentence.size
      end
    end
  end
end