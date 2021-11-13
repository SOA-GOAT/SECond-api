# frozen_string_literal: true

require_relative 'command'

module SECond
  module Submission
    # Blame output for a single file
    class SubmissionFile
      attr_reader :filename

      def initialize(filename)
        @filename = filename
      end

      def blame
        @blame ||= Command.new
          .with_porcelain
          .blame(@filename)
          .call
      end
    end
  end
end
