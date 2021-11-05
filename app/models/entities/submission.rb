# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

# require_relative 'member' # Another entity.rb

module SECond
  module Entity
    # Domain entity for any firms
    class Submission < Dry::Struct
      include Dry.Types

      attribute :sic,               Strict::String
      attribute :accession_number,  Strict::String
      attribute :form_type,         Strict::String
      attribute :filing_date,       Strict::String
      attribute :reporting_date,    Strict::String
      attribute :size,              Strict::String
    end
  end
end
