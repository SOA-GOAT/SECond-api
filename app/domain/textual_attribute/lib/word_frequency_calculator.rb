# frozen_string_literal: true

require 'words_counted'
require 'stopwords'

module SECond
  module Mixins
    # Word frequency calculation methods
    module WordFrequencyCalculator
      def word_frequency
        document = @sentences.join(' ')
        filter = Stopwords::Snowball::Filter.new "en"
        counter = WordsCounted.count(document, exclude: ->(t) { filter.stopword? t })
        counter.token_frequency[0..149].select { |term_frequency| term_frequency[0].length > 2}
      end
    end
  end
end
