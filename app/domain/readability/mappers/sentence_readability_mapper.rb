# frozen_string_literal: true

# require_relative 'blame_contributor'

module SECond
  module Mapper
    # Summarizes a single file's contributions by team members
    class SentenceReadability
      def initialize(sentence)
        @sentence = sentence
      end

      # def to_entity
      #   code_str = BlameCodeString.new(@line_report['code']).strip_leading_tab

      #   Entity::SentenceReadability.new(
      #     contributor: BlameContributor.new(@line_report).to_entity,
      #     code: @language.new(code_str),
      #     time: Time.at(@line_report['author-time'].to_i),
      #     number: @line_index + 1 # line numbers are one more than index count
      #   )
      # end

      def to_entity
        Entity::SentenceReadability.new(
          sentence: @sentence
        )
      end
    end

    # BlameCodeString = Struct.new(:code) do
    #   # remove leading tab from git blame code output
    #   def strip_leading_tab
    #     code[1..]
    #   end
    # end
  end
end
