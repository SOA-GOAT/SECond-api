# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

# require_relative 'member.rb'

module SECond
  module Entity
    # Domain entity for any firms
    class Firm < Dry::Struct
      include Dry.Types

      attribute :sic,               Strict::Integer
      attribute :sic_description,   Strict::String
      attribute :name,              Strict::String
      attribute :tickers,           Strict::Array
    end
  end
end