# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:firms) do
      primary_key :id 

      Integer     :cik, unique: true # yo
      String      :name, null: false
      String      :sic, null: false
      String      :sic_description
      Array       :tickers # Not sure if Sequel supports Array.

      DateTime :created_at
      DateTime :updated_at
    end
  end
end