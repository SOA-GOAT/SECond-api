# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

require_relative 'submission'

module SECond
  module Entity
    # Domain entity for any firms
    class Firm < Dry::Struct
      include Dry.Types

      attribute :id,                Integer.optional
      attribute :cik,               Strict::String
      attribute :sic,               Strict::String
      attribute :sic_description,   Strict::String
      attribute :name,              Strict::String
      attribute :tickers,           Strict::Array
      attribute :submissions,       Strict::Array.of(Submission)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id submissions].include? key }
      end

    end
  end
end
